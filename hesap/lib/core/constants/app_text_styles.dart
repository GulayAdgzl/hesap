import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const pageTitle = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w800,
    fontSize: 24,
    color: AppColors.dark,
  );

  static const sheetTitle = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const sectionTitle = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 15,
  );

  static const productName = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const productMeta = TextStyle(
    fontSize: 11,
    color: AppColors.muted,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    letterSpacing: .5,
  );

  static const hint = TextStyle(
    color: AppColors.inputHint,
    fontSize: 13,
  );

  static const caption = TextStyle(
    fontSize: 11,
    color: AppColors.muted,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: Colors.white,
  );

  static const chipText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const badgeText = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.primary,
  );

  static const dateCaption = TextStyle(
    fontSize: 11,
    color: AppColors.muted,
  );

  static const pageSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.muted,
  );

  static const quantityLarge = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: AppColors.dark,
  );

  static const quantityLargeDanger = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: AppColors.danger,
  );

  static const consumptionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const consumptionValue = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static const inputValue = TextStyle(
    fontFamily: 'Syne',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.dark,
  );

  static const criticalBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.danger,
  );

  // Settings
  static const settingsSectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.settingsSectionLabel,
    letterSpacing: .8,
  );

  static const settingsRowTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static const settingsRowSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.muted,
  );

  static const settingsRowValue = TextStyle(
    fontFamily: 'Syne',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const settingsLogoutButton = TextStyle(
    fontFamily: 'Syne',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.settingsLogoutText,
  );
}
