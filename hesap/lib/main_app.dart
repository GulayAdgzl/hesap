import 'package:flutter/material.dart';
import 'package:hesap/core/navigation/main_navigator.dart';
import 'package:hesap/core/theme/app_theme.dart';
import 'package:hesap/feature/settings/domain/usecases/get_settings.dart';
import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/product/initialize/injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _DarkModeWrapper(
      getSettings: sl<GetSettings>(),
      builder: (isDark) => MaterialApp(
        title: 'A\'la Profiterol',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: MainNavigation(
          getSettings: sl(),
          saveSetting: sl(),
          settingsRepository: sl(),
          notificationService: sl(),
          getAllProducts: sl(),
          addProduct: sl(),
          updateProduct: sl(),
          deleteProduct: sl(),
          saveDailyEntries: sl(),
          getLastEntry: sl(),
          getReportSummary: sl(),
          csvExportService: sl<CsvExportService>(),
          getHomeSummary: sl(),
        ),
      ),
    );
  }
}

// ── Dark mode ValueNotifier sarmalayıcısı ──────────────────────────────────
//
// SettingsCubit'in tek kullanım amacı buydu: darkMode değiştiğinde
// MaterialApp'i yeniden build etmek. Bunu ValueNotifier ile minimal
// şekilde çözüyoruz; Bloc/Cubit bağımlılığı tamamen kaldırıldı.

final class _DarkModeWrapper extends StatefulWidget {
  const _DarkModeWrapper({
    required this.getSettings,
    required this.builder,
  });

  final GetSettings getSettings;
  final Widget Function(bool isDark) builder;

  @override
  State<_DarkModeWrapper> createState() => _DarkModeWrapperState();
}

final class _DarkModeWrapperState extends State<_DarkModeWrapper> {
  final ValueNotifier<bool> _isDark = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final result = await widget.getSettings();
    result.fold(
      (_) => null,
      (settings) {
        if (mounted) _isDark.value = settings.darkMode;
      },
    );
  }

  @override
  void dispose() {
    _isDark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDark,
      builder: (_, isDark, __) => widget.builder(isDark),
    );
  }
}
