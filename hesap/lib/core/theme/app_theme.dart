import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
          surface: AppColors.surface,
          error: AppColors.danger,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.dark,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primaryLight,
          thumbColor: AppColors.primary,
          trackHeight: 4,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.muted,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primaryLight
                : AppColors.inputFill,
          ),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
          surface: const Color(0xFF1E1E2E),
          error: AppColors.danger,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: Color(0xFF2E2E4E),
          thumbColor: AppColors.primary,
          trackHeight: 4,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primary
                : const Color(0xFF6E6E8E),
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? const Color(0xFF2E2E5E)
                : const Color(0xFF2A2A3A),
          ),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        cardColor: const Color(0xFF1E1E2E),
        dividerColor: const Color(0xFF2E2E4E),
      );
}
