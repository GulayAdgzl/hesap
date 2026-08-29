import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_language.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';

import '../mixin/settings_page_mixin.dart';
import '../view_model/settings_view_model.dart';
import '../widgets/settings_action_row.dart';
import '../widgets/settings_avatar.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_toggle_row.dart';

part 'settings_page_parts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.viewModel,
  });

  // DailyEntryPage({required this.viewModel}) ile birebir aynı desen.
  final SettingsViewModel viewModel;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

final class _SettingsPageState extends State<SettingsPage>
    with SettingsPageMixin<SettingsPage> {
  // ── SettingsPageMixin → viewModel artık widget'tan okunuyor ────────────────

  @override
  SettingsViewModel get viewModel => widget.viewModel;

  // ── Sabit widget'lar (her build'de yeniden oluşturulmaz) ──────────────────

  static const _loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: viewModel.state,
          builder: (context, state, _) {
            if (state.isLoading || (!state.hasSettings && !state.hasError)) {
              return _loadingWidget;
            }
            if (state.hasError && !state.hasSettings) {
              return _ErrorBody(
                message: state.error!,
                onRetry: viewModel.loadSettings,
              );
            }
            return _buildLoaded(context, state.settings!);
          },
        ),
      ),
    );
  }

  // ── Yüklenmiş içerik ──────────────────────────────────────────────────────

  Widget _buildLoaded(BuildContext context, AppSettings s) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildAvatar(),
        _buildStockSection(context, s.criticalStockThreshold, s.forecastPeriod),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
        _buildNotificationsSection(
          context,
          criticalStock: s.criticalStockNotification,
          dailySummary: s.dailySummary,
          productionForecast: s.productionForecast,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
        _buildAppSection(context,
            darkMode: s.darkMode, languageCode: s.language),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
        _buildLogoutButton(context),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxxl)),
      ],
    );
  }

  // ── Section builder'ları (değişmedi) ────────────────────────────────────────

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.xl,
          AppSizes.base,
          AppSizes.xl,
          0,
        ),
        child: Text(
          AppStrings.settingsTitle,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAvatar() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.xl),
        child: SettingsAvatar(),
      ),
    );
  }

  SliverToBoxAdapter _buildStockSection(
    BuildContext context,
    double criticalStockThreshold,
    int forecastPeriod,
  ) {
    return SliverToBoxAdapter(
      child: _SectionWrapper(
        title: AppStrings.settingsSectionStock,
        children: [
          SettingsActionRow(
            icon: Icons.warning_amber_rounded,
            iconBg: context.appTheme.warningContainer,
            iconColor: context.appTheme.warning,
            title: AppStrings.settingsKritikStokEsigi,
            subtitle: AppStrings.settingsKritikStokEsigiSubtitle,
            value: '%${criticalStockThreshold.toStringAsFixed(0)}',
            onTap: () => showThresholdPicker(criticalStockThreshold),
          ),
          const _RowDivider(),
          SettingsActionRow(
            icon: Icons.calendar_today_rounded,
            iconBg: context.appTheme.brandSecondary,
            iconColor: context.appTheme.brandPrimary,
            title: AppStrings.settingsTahminPeriyodu,
            subtitle: AppStrings.settingsTahminPeriyoduSubtitle,
            value: '$forecastPeriod${AppStrings.settingsTahminPeriyoduSuffix}',
            onTap: () => showForecastPeriodPicker(forecastPeriod),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildNotificationsSection(
    BuildContext context, {
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
            iconBg: context.appTheme.dangerContainer,
            iconColor: context.appTheme.danger,
            title: AppStrings.settingsKritikStokBildirimLabel,
            subtitle: AppStrings.settingsKritikStokBildirimSubtitle,
            value: criticalStock,
            onChanged: viewModel.updateCriticalStockNotification,
          ),
          const _RowDivider(),
          SettingsToggleRow(
            icon: Icons.summarize_rounded,
            iconBg: context.appTheme.brandSecondary,
            iconColor: context.appTheme.brandPrimary,
            title: AppStrings.settingsGunlukOzetLabel,
            subtitle: AppStrings.settingsGunlukOzetSubtitle,
            value: dailySummary,
            onChanged: viewModel.updateDailySummary,
          ),
          const _RowDivider(),
          SettingsToggleRow(
            icon: Icons.precision_manufacturing_rounded,
            iconBg: context.appTheme.successContainer,
            iconColor: context.appTheme.success,
            title: AppStrings.settingsUretimTahminiLabel,
            subtitle: AppStrings.settingsUretimTahminiSubtitle,
            value: productionForecast,
            onChanged: viewModel.updateProductionForecast,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildAppSection(
    BuildContext context, {
    required bool darkMode,
    required String languageCode,
  }) {
    final language = AppLanguage.fromCode(languageCode);
    return SliverToBoxAdapter(
      child: _SectionWrapper(
        title: AppStrings.settingsSectionApp,
        children: [
          SettingsToggleRow(
            icon: Icons.dark_mode_rounded,
            iconBg: context.appTheme.brandSecondary,
            iconColor: context.appTheme.brandPrimary,
            title: AppStrings.settingsKoyuTemaLabel,
            value: darkMode,
            onChanged: viewModel.updateDarkMode,
          ),
          const _RowDivider(),
          SettingsActionRow(
            icon: Icons.language_rounded,
            iconBg: context.appTheme.brandSecondary,
            iconColor: context.appTheme.brandPrimary,
            title: AppStrings.settingsDilLabel,
            // Ekranda her zaman label gösterilir, persist edilen kod değil.
            value: language.label,
            onTap: () => showLanguagePicker(languageCode),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildLogoutButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: _LogoutButton(onTap: showLogoutDialog),
    );
  }
}
