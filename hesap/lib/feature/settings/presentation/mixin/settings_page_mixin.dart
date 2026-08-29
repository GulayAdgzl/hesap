import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_language.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../view_model/settings_ui_state.dart';
import '../view_model/settings_view_model.dart';

mixin SettingsPageMixin<T extends StatefulWidget> on State<T> {
  /// DailyEntryPage'deki gibi: ViewModel artık dışarıdan (MainNavigation'dan)
  /// enjekte ediliyor, mixin kendi başına inşa etmiyor.
  SettingsViewModel get viewModel;

  // ── Son gösterilen hata event'i ────────────────────────────────────────────
  // Paylaşılan state'e "tükettim" diye geri yazmak yerine, hangi event'i
  // zaten gösterdiğimizi burada, lokal olarak tutuyoruz. Karşılaştırma
  // `identical` ile yapılır: her yeni SettingsErrorEvent kendine özgü bir
  // nesne olduğu için, aynı mesaj metni tekrar gelse bile ayrı bir event
  // olarak algılanır ve tekrar gösterilir. Art arda hızlı hatalarda önceki
  // implementasyondaki callback çakışması/race condition burada oluşamaz —
  // hiçbir yazma-geri işlemi yok, sadece okuma ve karşılaştırma.
  SettingsErrorEvent? _lastShownErrorEvent;

  // ── Yaşam döngüsü ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // MainNavigation zaten ilk yüklemeyi yapıyor (..loadSettings() ile),
    // burada tekrar tetiklemeye gerek yok.
    viewModel.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    viewModel.state.removeListener(_onStateChanged);
    // ⚠️ viewModel.dispose() ARTIK BURADA ÇAĞRILMIYOR.
    // Sahiplik MainNavigation'da; page widget'ı sadece dinleyici.
    super.dispose();
  }

  // ── State dinleyici ────────────────────────────────────────────────────────

  void _onStateChanged() {
    final event = viewModel.state.value.errorEvent;

    // event == null           → şu an gösterilecek hata yok.
    // identical(event, last)  → bu event'i zaten gösterdik, tekrar gösterme.
    if (event == null || identical(event, _lastShownErrorEvent)) return;

    _lastShownErrorEvent = event;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event.message),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorderRadius,
        ),
      ),
    );
  }

  // ── Bottom sheet aksiyonları ───────────────────────────────────────────────
  // (değişmedi)

  void showThresholdPicker(double current) {
    double selected = current;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => _SettingsSheet(
          children: [
            Text(
              AppStrings.settingsKritikStokEsigi,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              AppStrings.settingsKritikStokEsigiSubtitle,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: context.appTheme.muted),
            ),
            const SizedBox(height: AppSizes.xl),
            Center(
              child: Text(
                '%${selected.toStringAsFixed(0)}',
                style: context.textTheme.headlineSmall,
              ),
            ),
            Slider(
              value: selected,
              min: 5,
              max: 50,
              divisions: 9,
              onChanged: (v) => setSheetState(() => selected = v),
            ),
            const SizedBox(height: AppSizes.sm),
            _SheetPrimaryButton(
              label: AppStrings.save,
              onPressed: () {
                viewModel.updateCriticalStockThreshold(selected);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showForecastPeriodPicker(int current) {
    const options = [3, 7, 14, 30];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(
        children: [
          Text(
            AppStrings.settingsTahminPeriyodu,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.settingsTahminPeriyoduSubtitle,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appTheme.muted),
          ),
          const SizedBox(height: AppSizes.base),
          ...options.map(
            (days) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '$days${AppStrings.settingsTahminPeriyoduSuffix}',
                style: context.textTheme.labelLarge,
              ),
              trailing: current == days
                  ? Icon(Icons.check_rounded, color: context.colors.primary)
                  : null,
              onTap: () {
                viewModel.updateForecastPeriod(days);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }

  /// [current] artık locale kodu (örn. 'tr'), display label değil.
  void showLanguagePicker(String current) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(
        children: [
          Text(
            AppStrings.settingsDilLabel,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.base),
          ...AppLanguage.values.map((lang) {
            final isSelected = current == lang.code;
            return GestureDetector(
              onTap: () {
                viewModel.updateLanguage(lang.code);
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSizes.sm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.base,
                  vertical: AppSizes.md,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.appTheme.brandSecondary
                      : context.appTheme.inputFill,
                  borderRadius: AppRadius.mdBorderRadius,
                  border: isSelected
                      ? Border.all(
                          color: context.colors.primary.withOpacity(0.3),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Text(lang.flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        lang.label,
                        style: context.textTheme.labelLarge,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        color: context.colors.primary,
                        size: AppSizes.iconMd,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appTheme.cardBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.lgBorderRadius,
        ),
        title: Text(
          AppStrings.settingsLogoutConfirmTitle,
          style: context.textTheme.titleMedium,
        ),
        content: Text(
          AppStrings.settingsLogoutConfirmMessage,
          style: context.textTheme.bodySmall
              ?.copyWith(color: context.appTheme.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.cancel,
              style: context.textTheme.labelLarge
                  ?.copyWith(color: context.appTheme.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.clearSettings();
            },
            child: Text(
              AppStrings.settingsLogoutConfirm,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.appTheme.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kolay erişim getter'ı ──────────────────────────────────────────────────

  SettingsUiState get currentState => viewModel.state.value;
}

// ── Mixin'in kullandığı private sheet widget'ları ──────────────────────────

final class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.xl,
        AppSizes.base,
        AppSizes.xl,
        AppSizes.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          const SizedBox(height: AppSizes.lg),
          ...children,
        ],
      ),
    );
  }
}

final class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

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

final class _SheetPrimaryButton extends StatelessWidget {
  const _SheetPrimaryButton({
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
          padding: const EdgeInsets.symmetric(vertical: AppSizes.base),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.mdBorderRadius,
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
