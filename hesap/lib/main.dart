import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/models/daily_stock_entry_model.dart';
import 'package:hesap/core/models/product_model.dart';
import 'package:hesap/core/navigation/main_navigator.dart';
import 'package:hesap/core/service/notification_service.dart';
import 'package:hesap/core/theme/app_theme.dart';

import 'package:hesap/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:hesap/features/settings/presentation/bloc/settings_state.dart';

import 'package:hesap/injection_container.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(DailyStockEntryModelAdapter());

  await init();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) {
          if (prev is SettingsLoaded && curr is SettingsLoaded) {
            return prev.settings.darkMode != curr.settings.darkMode;
          }
          return curr is SettingsLoaded;
        },
        builder: (context, state) {
          final isDark =
              state is SettingsLoaded ? state.settings.darkMode : false;

          return MaterialApp(
            title: 'Hesap App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}
