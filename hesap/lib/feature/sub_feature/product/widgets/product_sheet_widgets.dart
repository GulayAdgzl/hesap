import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

// ── Sheet handle ───────────────────────────────────────────────────────────

final class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSizes.xxxl,
        height: AppSizes.xs,
        decoration: BoxDecoration(
          color: context.appTheme.inputHint,
          borderRadius: AppRadius.xsBorderRadius,
        ),
      ),
    );
  }
}

// ── Sheet close button ─────────────────────────────────────────────────────

final class SheetCloseButton extends StatelessWidget {
  const SheetCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: AppSizes.xxl + AppSizes.xs,
        height: AppSizes.xxl + AppSizes.xs,
        decoration: BoxDecoration(
          color: context.appTheme.inputFill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          size: AppSizes.iconSm + 2,
          color: context.appTheme.muted,
        ),
      ),
    );
  }
}

// ── Unit chip selector ─────────────────────────────────────────────────────

final class UnitChipSelector extends StatelessWidget {
  const UnitChipSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.xs,
      children: AppStrings.units.map((u) {
        final isSel = u == selected;
        return GestureDetector(
          onTap: () => onSelect(u),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.base,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: isSel
                  ? context.colors.primary
                  : context.appTheme.inputFill,
              borderRadius: AppRadius.fullBorderRadius,
              border: Border.all(
                color: isSel
                    ? context.colors.primary
                    : context.appTheme.divider,
              ),
            ),
            child: Text(
              u,
              style: context.textTheme.labelMedium?.copyWith(
                color: isSel ? Colors.white : context.appTheme.muted,
                fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Critical threshold slider ──────────────────────────────────────────────

final class CriticalThresholdSlider extends StatelessWidget {
  const CriticalThresholdSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.criticalThreshold,
              style: context.textTheme.labelMedium
                  ?.copyWith(color: context.appTheme.muted),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm + 2,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: context.appTheme.brandSecondary,
                borderRadius: AppRadius.fullBorderRadius,
              ),
              child: Text(
                '%${value.round()}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            overlayColor: context.colors.primary.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          ),
          child: Slider(
            value: value,
            min: 5,
            max: 50,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),
        Text(
          AppStrings.criticalThresholdHint,
          style: context.textTheme.bodySmall
              ?.copyWith(color: context.appTheme.muted),
        ),
      ],
    );
  }
}

// ── Sheet primary button ───────────────────────────────────────────────────

final class SheetPrimaryButton extends StatelessWidget {
  const SheetPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md + 3),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.baseBorderRadius,
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.labelLarge
              ?.copyWith(color: context.colors.onPrimary),
        ),
      ),
    );
  }
}

// ── Shared input decoration builder ───────────────────────────────────────

InputDecoration sheetInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: context.appTheme.inputHint, fontSize: 14),
    filled: true,
    fillColor: context.appTheme.inputFill,
    isDense: true,
    contentPadding: AppPadding.inputPadding,
    border: OutlineInputBorder(
      borderRadius: AppRadius.smBorderRadius,
      borderSide: BorderSide(color: context.appTheme.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.smBorderRadius,
      borderSide: BorderSide(color: context.appTheme.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.smBorderRadius,
      borderSide: BorderSide(color: context.colors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.smBorderRadius,
      borderSide: BorderSide(color: context.appTheme.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.smBorderRadius,
      borderSide: BorderSide(color: context.appTheme.danger, width: 1.5),
    ),
  );
}