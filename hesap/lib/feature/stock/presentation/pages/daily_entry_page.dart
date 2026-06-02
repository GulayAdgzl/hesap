import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_state.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_header.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_list.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_save_button.dart';

class DailyEntryPage extends StatefulWidget {
  const DailyEntryPage({super.key});

  @override
  State<DailyEntryPage> createState() => _DailyEntryPageState();
}

class _DailyEntryPageState extends State<DailyEntryPage> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    context.read<DailyEntryCubit>().loadProducts();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  TextEditingController _controllerFor(String productId) =>
      _controllers.putIfAbsent(productId, () => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<DailyEntryCubit, DailyEntryState>(
        listener: (context, state) {
          if (state is DailyEntrySaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(AppStrings.dailyEntrySaved),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
            context.read<DailyEntryCubit>().loadProducts();
          }
          if (state is DailyEntryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const DailyEntryHeader(),
              Expanded(
                child: DailyEntryList(controllerFor: _controllerFor),
              ),
              const DailyEntrySaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
