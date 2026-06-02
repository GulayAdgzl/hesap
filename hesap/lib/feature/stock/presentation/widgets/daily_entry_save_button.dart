import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';

class DailyEntrySaveButton extends StatelessWidget {
  const DailyEntrySaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.read<DailyEntryCubit>().saveAll(),
          icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
          label: const Text(
            AppStrings.dailyEntrySaveAll,
            style: AppTextStyles.buttonText,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
