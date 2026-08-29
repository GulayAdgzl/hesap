import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_system.dart';
import 'app_theme_extension.dart';

abstract final class AppTheme {
  AppTheme._();

  // ── Text Theme ─────────────────────────────────────────────────────────────

  /// Syne — display, headline, title, label (brand voice)
  /// System sans-serif — body (okunabilirlik)
  static const String _syne = 'Syne';

  static final TextTheme _textTheme = const TextTheme(
    // Display — Syne, büyük tanıtım metinleri
    displayLarge: const TextStyle(
      fontFamily: _syne,
      fontSize: 57,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: const TextStyle(
      fontFamily: _syne,
      fontSize: 45,
      fontWeight: FontWeight.w800,
      height: 1.16,
    ),
    displaySmall: const TextStyle(
      fontFamily: _syne,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.22,
    ),
    // Headline — Syne, sayfa ve bölüm başlıkları
    headlineLarge: const TextStyle(
      fontFamily: _syne,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    headlineMedium: const TextStyle(
      fontFamily: _syne,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.29,
    ),
    headlineSmall: const TextStyle(
      fontFamily: _syne,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.33,
    ),
    // Title — Syne, kart ve dialog başlıkları
    titleLarge: const TextStyle(
      fontFamily: _syne,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.27,
    ),
    titleMedium: const TextStyle(
      fontFamily: _syne,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: const TextStyle(
      fontFamily: _syne,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    // Body — sistem fontu, uzun metin okunabilirliği
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    // Label — Syne, buton, chip, badge metinleri
    labelLarge: const TextStyle(
      fontFamily: _syne,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: const TextStyle(
      fontFamily: _syne,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: const TextStyle(
      fontFamily: _syne,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // ── Shared widget themes ───────────────────────────────────────────────────

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.surface,
      elevation: 0,
      minimumSize: const Size.fromHeight(AppSizes.buttonMd),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.baseBorderRadius,
      ),
      textStyle: _textTheme.labelLarge,
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: const Size.fromHeight(AppSizes.buttonMd),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.baseBorderRadius,
      ),
      side: const BorderSide(color: AppColors.primary),
      textStyle: _textTheme.labelLarge,
    ),
  );

  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.surface,
    elevation: 4,
  );

  static const _progressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColors.primary,
  );

  static const _sliderThemeLight = SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.primaryLight,
    thumbColor: AppColors.primary,
    trackHeight: 4,
  );

  static final _sliderThemeDark = const SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.darkTrack,
    thumbColor: AppColors.primary,
    trackHeight: 4,
  );

  static final _switchThemeLight = SwitchThemeData(
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
  );

  static final _switchThemeDark = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (s) => s.contains(WidgetState.selected)
          ? AppColors.primary
          : AppColors.darkThumbOff,
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (s) => s.contains(WidgetState.selected)
          ? AppColors.darkTrackSelected
          : AppColors.darkSwitchTrackOff,
    ),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  );

  static final _inputDecorationThemeLight = const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    hintStyle: TextStyle(color: AppColors.inputHint, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: AppRadius.mdBorderRadius,
      borderSide: BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdBorderRadius,
      borderSide: BorderSide(color: AppColors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdBorderRadius,
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: AppPadding.inputPadding,
  );

  // ── Light Theme ────────────────────────────────────────────────────────────

  static final ThemeData light = ThemeData(
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
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.dark,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.baseBorderRadius,
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    sliderTheme: _sliderThemeLight,
    switchTheme: _switchThemeLight,
    inputDecorationTheme: _inputDecorationThemeLight,
    dividerTheme: const DividerThemeData(
      color: AppColors.settingsDivider,
      thickness: 1,
      space: 0,
    ),
    extensions: [AppThemeExtension.light],
  );

  // ── Dark Theme ─────────────────────────────────────────────────────────────

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.darkTrackSelected,
      surface: AppColors.darkSurface,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: _textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.baseBorderRadius,
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    sliderTheme: _sliderThemeDark,
    switchTheme: _switchThemeDark,
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 0,
    ),
    extensions: [AppThemeExtension.dark],
  );
}
