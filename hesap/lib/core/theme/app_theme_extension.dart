import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.danger,
    required this.dangerContainer,
    required this.cardBackground,
    required this.divider,
    required this.inputFill,
    required this.inputHint,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.muted,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color danger;
  final Color dangerContainer;
  final Color cardBackground;
  final Color divider;
  final Color inputFill;
  final Color inputHint;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color muted;

  // ── Static instances ───────────────────────────────────────────────────────

  static final AppThemeExtension light = const AppThemeExtension(
    brandPrimary: AppColors.primary,
    brandSecondary: AppColors.primaryLight,
    success: AppColors.success,
    successContainer: AppColors.successLight,
    warning: AppColors.warning,
    warningContainer: AppColors.warningLight,
    info: AppColors.primary,
    danger: AppColors.danger,
    dangerContainer: AppColors.dangerLight,
    cardBackground: AppColors.surface,
    divider: AppColors.settingsDivider,
    inputFill: AppColors.inputFill,
    inputHint: AppColors.inputHint,
    shimmerBase: AppColors.shimmerBaseLigh,
    shimmerHighlight: AppColors.shimmerHighlightLight,
    muted: AppColors.muted,
  );

  static final AppThemeExtension dark = const AppThemeExtension(
    brandPrimary: AppColors.primary,
    brandSecondary: AppColors.darkTrackSelected,
    success: AppColors.success,
    successContainer: const Color(0xFF1A3D30),
    warning: AppColors.warning,
    warningContainer: const Color(0xFF3D2E0A),
    info: AppColors.primary,
    danger: AppColors.danger,
    dangerContainer: const Color(0xFF3D1A1A),
    cardBackground: AppColors.darkSurface,
    divider: AppColors.darkDivider,
    inputFill: const Color(0xFF252535),
    inputHint: const Color(0xFF6060A0),
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
    muted: AppColors.darkThumbOff,
  );

  // ── ThemeExtension API ─────────────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? danger,
    Color? dangerContainer,
    Color? cardBackground,
    Color? divider,
    Color? inputFill,
    Color? inputHint,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? muted,
  }) {
    return AppThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      danger: danger ?? this.danger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      inputHint: inputHint ?? this.inputHint,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      muted: muted ?? this.muted,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}
