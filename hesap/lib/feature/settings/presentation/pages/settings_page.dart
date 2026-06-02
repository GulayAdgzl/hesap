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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Cubit bir kez alınır; her build'de context.read çağrısı yapılmaz.
  late final SettingsCubit _cubit;

  // Sabit widget — her rebuild'de yeni instance oluşturmaz.
  static const _loadingWidget = Center(
    child: CircularProgressIndicator(color: AppColors.primary),
  );

  // Sabit divider — her build'de yeni Divider oluşturmaz.
  static const _divider = Divider(
    height: 1,
    thickness: 1,
    color: AppColors.settingsDivider,
    indent: 56,
  );

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SettingsCubit>();
    _cubit.loadSettings();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: switch (state) {
            SettingsInitial() => _loadingWidget,
            SettingsLoading() => _loadingWidget,
            SettingsLoaded() => _buildLoaded(state),
            SettingsError() => _buildError(state.message),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  // ── State widget'ları ──────────────────────────────────────────────────────

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _cubit.loadSettings,
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(SettingsLoaded state) {
    final s = state.settings;

    return CustomScrollView(
      slivers: [
        _buildHeader(),
        _buildAvatar(),
        _buildStockSection(s.criticalStockThreshold, s.forecastPeriod),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        _buildNotificationsSection(
          criticalStock: s.criticalStockNotification,
          dailySummary: s.dailySummary,
          productionForecast: s.productionForecast,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        _buildAppSection(darkMode: s.darkMode, language: s.language),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        _buildLogoutButton(),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // ── Section builder'ları ───────────────────────────────────────────────────

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Text(AppStrings.settingsTitle, style: AppTextStyles.pageTitle),
      ),
    );
  }

  SliverToBoxAdapter _buildAvatar() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: SettingsAvatar(),
      ),
    );
  }

  SliverToBoxAdapter _buildStockSection(
    double criticalStockThreshold,
    int forecastPeriod,
  ) {
    return SliverToBoxAdapter(
      child: _SectionWrapper(
        title: AppStrings.settingsSectionStock,
        children: [
          SettingsActionRow(
            icon: Icons.warning_amber_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBoxWarning,
            iconColor: AppColors.warning,
            title: AppStrings.settingsKritikStokEsigi,
            subtitle: AppStrings.settingsKritikStokEsigiSubtitle,
            value: '%${criticalStockThreshold.toStringAsFixed(0)}',
            onTap: () => _showThresholdPicker(criticalStockThreshold),
          ),
          _divider,
          SettingsActionRow(
            icon: Icons.calendar_today_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBox,
            iconColor: AppColors.primary,
            title: AppStrings.settingsTahminPeriyodu,
            subtitle: AppStrings.settingsTahminPeriyoduSubtitle,
            value: '$forecastPeriod${AppStrings.settingsTahminPeriyoduSuffix}',
            onTap: () => _showForecastPeriodPicker(forecastPeriod),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildNotificationsSection({
    required bool criticalStock,
    required bool dailySummary,
    required bool productionForecast,
  }) {
    return SliverToBoxAdapter(
      child: _SectionWrapper(
        title: AppStrings.settingsSectionNotifications,
        children: [
          SettingsToggleRow(
            icon: Icons.notifications_active_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBoxDanger,
            iconColor: AppColors.danger,
            title: AppStrings.settingsKritikStokBildirimLabel,
            subtitle: AppStrings.settingsKritikStokBildirimSubtitle,
            value: criticalStock,
            onChanged: _cubit.updateCriticalStockNotification,
          ),
          _divider,
          SettingsToggleRow(
            icon: Icons.summarize_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBox,
            iconColor: AppColors.primary,
            title: AppStrings.settingsGunlukOzetLabel,
            subtitle: AppStrings.settingsGunlukOzetSubtitle,
            value: dailySummary,
            onChanged: _cubit.updateDailySummary,
          ),
          _divider,
          SettingsToggleRow(
            icon: Icons.precision_manufacturing_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBoxSuccess,
            iconColor: AppColors.success,
            title: AppStrings.settingsUretimTahminiLabel,
            subtitle: AppStrings.settingsUretimTahminiSubtitle,
            value: productionForecast,
            onChanged: _cubit.updateProductionForecast,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildAppSection({
    required bool darkMode,
    required String language,
  }) {
    return SliverToBoxAdapter(
      child: _SectionWrapper(
        title: AppStrings.settingsSectionApp,
        children: [
          SettingsToggleRow(
            icon: Icons.dark_mode_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBox,
            iconColor: AppColors.primary,
            title: AppStrings.settingsKoyuTemaLabel,
            value: darkMode,
            onChanged: _cubit.updateDarkMode,
          ),
          _divider,
          SettingsActionRow(
            icon: Icons.language_rounded,
            iconBoxDecoration: AppDecorations.settingsIconBox,
            iconColor: AppColors.primary,
            title: AppStrings.settingsDilLabel,
            value: language,
            onTap: () => _showLanguagePicker(language),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildLogoutButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: _showLogoutDialog,
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
    );
  }

  // ── Bottom sheet / dialog gösterme metodları ───────────────────────────────
  // Bu metodlar yalnızca UI akışını yönetir; iş mantığı içermez.

  void _showThresholdPicker(double current) {
    double selected = current;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) => Container(
          decoration: AppDecorations.sheet,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 20),
              Text(AppStrings.settingsKritikStokEsigi,
                  style: AppTextStyles.sheetTitle),
              const SizedBox(height: 4),
              Text(AppStrings.settingsKritikStokEsigiSubtitle,
                  style: AppTextStyles.pageSubtitle),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '%${selected.toStringAsFixed(0)}',
                  style: AppTextStyles.quantityLarge.copyWith(fontSize: 32),
                ),
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
              _PrimaryButton(
                label: AppStrings.save,
                onPressed: () {
                  _cubit.updateCriticalStockThreshold(selected);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForecastPeriodPicker(int current) {
    const options = [3, 7, 14, 30];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: AppDecorations.sheet,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
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
                  _cubit.updateForecastPeriod(days);
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

  void _showLanguagePicker(String current) {
    const languages = [
      ('Türkçe', '🇹🇷'),
      ('English', '🇬🇧'),
      ('Deutsch', '🇩🇪'),
      ('Français', '🇫🇷'),
      ('Español', '🇪🇸'),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: AppDecorations.sheet,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 20),
              Text(AppStrings.settingsDilLabel,
                  style: AppTextStyles.sheetTitle),
              const SizedBox(height: 16),
              ...languages.map(
                (lang) {
                  final isSelected = current == lang.$1;
                  return GestureDetector(
                    onTap: () {
                      _cubit.updateLanguage(lang.$1);
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
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
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
              _cubit.clearSettings();
            },
            child: Text(AppStrings.settingsLogoutConfirm,
                style: const TextStyle(color: AppColors.settingsLogoutText)),
          ),
        ],
      ),
    );
  }
}

class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(title: title),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.settingsCard,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet'lerin üstündeki tutma çubuğu.
class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.handle,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Bottom sheet'lerde kullanılan tam genişlikli birincil buton.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
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
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label, style: AppTextStyles.buttonText),
      ),
    );
  }
}
