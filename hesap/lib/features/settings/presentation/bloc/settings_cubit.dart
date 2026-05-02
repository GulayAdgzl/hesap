import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/service/notification_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings getSettings;
  final SaveSetting saveSetting;
  final SettingsRepository repository;
  final NotificationService notificationService;

  SettingsCubit({
    required this.getSettings,
    required this.saveSetting,
    required this.repository,
    NotificationService? notificationService,
  })  : notificationService =
            notificationService ?? NotificationService.instance,
        super(const SettingsInitial());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    final result = await getSettings();
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> updateCriticalStockThreshold(double value) async {
    await _save(AppStrings.keyCriticalStockThreshold, value);
  }

  Future<void> updateForecastPeriod(int value) async {
    await _save(AppStrings.keyForecastPeriod, value);
  }

  Future<void> updateCriticalStockNotification(bool value) async {
    await _save(AppStrings.keyCriticalStockNotification, value);
    await notificationService.applySettings(
      criticalStockNotification: value,
      dailySummary: _current?.dailySummary ?? true,
      productionForecast: _current?.productionForecast ?? false,
    );
  }

  Future<void> updateDailySummary(bool value) async {
    await _save(AppStrings.keyDailySummary, value);
    await notificationService.scheduleDailySummary(enabled: value);
  }

  Future<void> updateProductionForecast(bool value) async {
    await _save(AppStrings.keyProductionForecast, value);
    await notificationService.scheduleProductionForecast(enabled: value);
  }

  Future<void> updateDarkMode(bool value) async {
    await _save(AppStrings.keyDarkMode, value);
  }

  Future<void> updateLanguage(String value) async {
    await _save(AppStrings.keyLanguage, value);
  }

  Future<void> clearSettings() async {
    await notificationService.cancelAll();
    final result = await repository.clearSettings();
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (_) => emit(const SettingsInitial()),
    );
  }

  AppSettings? get _current =>
      state is SettingsLoaded ? (state as SettingsLoaded).settings : null;

  Future<void> _save(String key, dynamic value) async {
    if (state is! SettingsLoaded) return;
    final result = await saveSetting(key: key, value: value);
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (_) => loadSettings(),
    );
  }
}
