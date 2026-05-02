import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_decorations.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_action_row.dart';
import '../widgets/settings_avatar.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_toggle_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: switch (state) {
              SettingsInitial() => _buildInitial(context),
              SettingsLoading() => _buildLoading(),
              SettingsLoaded() => _buildLoaded(context, state),
              SettingsError() => _buildError(context, state.message),
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }

  Widget _buildInitial(BuildContext context) {
    context.read<SettingsCubit>().loadSettings();
    return _buildLoading();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.read<SettingsCubit>().loadSettings(),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, SettingsLoaded state) {
    final settings = state.settings;
    final cubit = context.read<SettingsCubit>();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(
              AppStrings.settingsTitle,
              style: AppTextStyles.pageTitle,
            ),
          ),
        ),

        // Avatar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const SettingsAvatar(),
          ),
        ),

        // STOK AYARLARI
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsSectionHeader(
                  title: AppStrings.settingsSectionStock,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: AppDecorations.settingsCard,
                  child: Column(
                    children: [
                      SettingsActionRow(
                        icon: Icons.warning_amber_rounded,
                        iconBoxDecoration:
                            AppDecorations.settingsIconBoxWarning,
                        iconColor: AppColors.warning,
                        title: AppStrings.settingsKritikStokEsigi,
                        subtitle: AppStrings.settingsKritikStokEsigiSubtitle,
                        value:
                            '%${settings.criticalStockThreshold.toStringAsFixed(0)}',
                        onTap: () => _showThresholdPicker(
                            context, cubit, settings.criticalStockThreshold),
                      ),
                      _divider(),
                      SettingsActionRow(
                        icon: Icons.calendar_today_rounded,
                        iconBoxDecoration: AppDecorations.settingsIconBox,
                        iconColor: AppColors.primary,
                        title: AppStrings.settingsTahminPeriyodu,
                        subtitle: AppStrings.settingsTahminPeriyoduSubtitle,
                        value:
                            '${settings.forecastPeriod}${AppStrings.settingsTahminPeriyoduSuffix}',
                        onTap: () => _showForecastPeriodPicker(
                            context, cubit, settings.forecastPeriod),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // BİLDİRİMLER
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsSectionHeader(
                  title: AppStrings.settingsSectionNotifications,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: AppDecorations.settingsCard,
                  child: Column(
                    children: [
                      SettingsToggleRow(
                        icon: Icons.notifications_active_rounded,
                        iconBoxDecoration: AppDecorations.settingsIconBoxDanger,
                        iconColor: AppColors.danger,
                        title: AppStrings.settingsKritikStokBildirimLabel,
                        subtitle: AppStrings.settingsKritikStokBildirimSubtitle,
                        value: settings.criticalStockNotification,
                        onChanged: cubit.updateCriticalStockNotification,
                      ),
                      _divider(),
                      SettingsToggleRow(
                        icon: Icons.summarize_rounded,
                        iconBoxDecoration: AppDecorations.settingsIconBox,
                        iconColor: AppColors.primary,
                        title: AppStrings.settingsGunlukOzetLabel,
                        subtitle: AppStrings.settingsGunlukOzetSubtitle,
                        value: settings.dailySummary,
                        onChanged: cubit.updateDailySummary,
                      ),
                      _divider(),
                      SettingsToggleRow(
                        icon: Icons.precision_manufacturing_rounded,
                        iconBoxDecoration:
                            AppDecorations.settingsIconBoxSuccess,
                        iconColor: AppColors.success,
                        title: AppStrings.settingsUretimTahminiLabel,
                        subtitle: AppStrings.settingsUretimTahminiSubtitle,
                        value: settings.productionForecast,
                        onChanged: cubit.updateProductionForecast,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // UYGULAMA
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsSectionHeader(
                  title: AppStrings.settingsSectionApp,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: AppDecorations.settingsCard,
                  child: Column(
                    children: [
                      SettingsToggleRow(
                        icon: Icons.dark_mode_rounded,
                        iconBoxDecoration: AppDecorations.settingsIconBox,
                        iconColor: AppColors.primary,
                        title: AppStrings.settingsKoyuTemaLabel,
                        value: settings.darkMode,
                        onChanged: cubit.updateDarkMode,
                      ),
                      _divider(),
                      SettingsActionRow(
                        icon: Icons.language_rounded,
                        iconBoxDecoration: AppDecorations.settingsIconBox,
                        iconColor: AppColors.primary,
                        title: AppStrings.settingsDilLabel,
                        value: settings.language,
                        onTap: () => _showLanguagePicker(
                            context, cubit, settings.language),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Çıkış Yap
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () => _showLogoutDialog(context, cubit),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: AppDecorations.settingsLogoutButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: AppColors.settingsLogoutText,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.settingsLogout,
                      style: AppTextStyles.settingsLogoutButton,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.settingsDivider,
        indent: 56,
      );

  void _showThresholdPicker(
    BuildContext context,
    SettingsCubit cubit,
    double current,
  ) {
    double selected = current;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          decoration: AppDecorations.sheet,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.handle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.settingsKritikStokEsigi,
                  style: AppTextStyles.sheetTitle),
              const SizedBox(height: 4),
              Text(AppStrings.settingsKritikStokEsigiSubtitle,
                  style: AppTextStyles.pageSubtitle),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '%${selected.toStringAsFixed(0)}',
                    style: AppTextStyles.quantityLarge.copyWith(fontSize: 32),
                  ),
                ],
              ),
              Slider(
                value: selected,
                min: 5,
                max: 50,
                divisions: 9,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primaryLight,
                onChanged: (v) => setState(() => selected = v),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cubit.updateCriticalStockThreshold(selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppStrings.save, style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForecastPeriodPicker(
    BuildContext context,
    SettingsCubit cubit,
    int current,
  ) {
    final options = [3, 7, 14, 30];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: AppDecorations.sheet,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.handle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppStrings.settingsTahminPeriyodu,
                style: AppTextStyles.sheetTitle),
            const SizedBox(height: 4),
            Text(AppStrings.settingsTahminPeriyoduSubtitle,
                style: AppTextStyles.pageSubtitle),
            const SizedBox(height: 16),
            ...options.map(
              (days) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '$days${AppStrings.settingsTahminPeriyoduSuffix}',
                  style: AppTextStyles.settingsRowTitle,
                ),
                trailing: current == days
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  cubit.updateForecastPeriod(days);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    SettingsCubit cubit,
    String current,
  ) {
    const languages = [
      ('Türkçe', '🇹🇷'),
      ('English', '🇬🇧'),
      ('Deutsch', '🇩🇪'),
      ('Français', '🇫🇷'),
      ('Español', '🇪🇸'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: AppDecorations.sheet,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.handle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppStrings.settingsDilLabel, style: AppTextStyles.sheetTitle),
            const SizedBox(height: 16),
            ...languages.map(
              (lang) {
                final isSelected = current == lang.$1;
                return GestureDetector(
                  onTap: () {
                    cubit.updateLanguage(lang.$1);
                    Navigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(lang.$2, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(lang.$1,
                              style: AppTextStyles.settingsRowTitle),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_rounded,
                              color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.settingsLogoutConfirmTitle,
            style: AppTextStyles.sheetTitle),
        content: Text(AppStrings.settingsLogoutConfirmMessage,
            style: AppTextStyles.pageSubtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel,
                style: const TextStyle(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.clearSettings();
            },
            child: Text(AppStrings.settingsLogoutConfirm,
                style: const TextStyle(color: AppColors.settingsLogoutText)),
          ),
        ],
      ),
    );
  }
}
