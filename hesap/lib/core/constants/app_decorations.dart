import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration get card => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get searchBar => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
      );

  static BoxDecoration get sheet => const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      );

  static InputDecoration inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inputHint, fontSize: 13),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
      );

  // Mevcut dosyaya şunları ekle:

  static BoxDecoration get entryCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get entryCardCritical => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.danger.withOpacity(0.3),
          width: 1.5,
        ),
      );

  static BoxDecoration get consumptionRowConsumed => BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(10),
      );

  static BoxDecoration get consumptionRowAdded => BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10),
      );

  static BoxDecoration get criticalBadge => BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(20),
      );

  static BoxDecoration cardIconNormal = BoxDecoration(
    color: AppColors.primaryLight,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration cardIconCritical = BoxDecoration(
    color: AppColors.dangerLight,
    borderRadius: BorderRadius.circular(12),
  );

  static InputDecoration entryInputDecoration() => InputDecoration(
        hintText: '0',
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 16),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      );
}
