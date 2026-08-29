import 'package:flutter/foundation.dart';
import 'package:hesap/core/constants/settings_keys.dart';
import 'package:hesap/module/notification/notification_service.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import 'settings_ui_state.dart';

final class SettingsViewModel {
  final GetSettings _getSettings;
  final SaveSetting _saveSetting;
  final SettingsRepository _repository;
  final NotificationService _notificationService;

  final ValueNotifier<SettingsUiState> state =
      ValueNotifier(const SettingsUiState.initial());

  SettingsViewModel({
    required GetSettings getSettings,
    required SaveSetting saveSetting,
    required SettingsRepository repository,
    required NotificationService notificationService,
  })  : _getSettings = getSettings,
        _saveSetting = saveSetting,
        _repository = repository,
        _notificationService = notificationService;

  // ── Yükleme ───────────────────────────────────────────────────────────────

  Future<void> loadSettings() async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    final result = await _getSettings();
    result.fold(
      (failure) => state.value = state.value.copyWith(
        isLoading: false,
        errorEvent: SettingsErrorEvent(failure.message),
      ),
      (settings) => state.value = state.value.copyWith(
        isLoading: false,
        settings: settings,
      ),
    );
  }

  // ── Stok ayarları ─────────────────────────────────────────────────────────

  Future<void> updateCriticalStockThreshold(double value) async {
    await _save(
      key: SettingsKeys.criticalStockThreshold,
      value: value,
      applyOptimistic: (s) => s.copyWith(criticalStockThreshold: value),
    );
  }

  Future<void> updateForecastPeriod(int value) async {
    await _save(
      key: SettingsKeys.forecastPeriod,
      value: value,
      applyOptimistic: (s) => s.copyWith(forecastPeriod: value),
    );
  }

  // ── Bildirim ayarları ─────────────────────────────────────────────────────

  Future<void> updateCriticalStockNotification(bool value) async {
    await _save(
      key: SettingsKeys.criticalStockNotification,
      value: value,
      applyOptimistic: (s) => s.copyWith(criticalStockNotification: value),
    );
    // NotificationService çağrısı, kaydetme başarılıysa güncel state'i kullanır.
    if (!currentState.hasError) {
      await _notificationService.applySettings(
        criticalStockNotification: value,
        dailySummary:
            _currentSettings?.dailySummary ?? AppSettings.defaults.dailySummary,
        productionForecast: _currentSettings?.productionForecast ??
            AppSettings.defaults.productionForecast,
      );
    }
  }

  Future<void> updateDailySummary(bool value) async {
    await _save(
      key: SettingsKeys.dailySummary,
      value: value,
      applyOptimistic: (s) => s.copyWith(dailySummary: value),
    );
    if (!currentState.hasError) {
      await _notificationService.scheduleDailySummary(enabled: value);
    }
  }

  Future<void> updateProductionForecast(bool value) async {
    await _save(
      key: SettingsKeys.productionForecast,
      value: value,
      applyOptimistic: (s) => s.copyWith(productionForecast: value),
    );
    if (!currentState.hasError) {
      await _notificationService.scheduleProductionForecast(enabled: value);
    }
  }

  // ── Uygulama ayarları ─────────────────────────────────────────────────────

  Future<void> updateDarkMode(bool value) async {
    await _save(
      key: SettingsKeys.darkMode,
      value: value,
      applyOptimistic: (s) => s.copyWith(darkMode: value),
    );
  }

  Future<void> updateLanguage(String value) async {
    await _save(
      key: SettingsKeys.language,
      value: value,
      applyOptimistic: (s) => s.copyWith(language: value),
    );
  }

  // ── Çıkış ─────────────────────────────────────────────────────────────────

  Future<void> clearSettings() async {
    await _notificationService.cancelAll();
    final result = await _repository.clearSettings();
    result.fold(
      (failure) => state.value = state.value.copyWith(
        errorEvent: SettingsErrorEvent(failure.message),
      ),
      (_) => state.value = const SettingsUiState.initial(),
    );
  }

  // ── Yardımcılar ───────────────────────────────────────────────────────────

  AppSettings? get _currentSettings => state.value.settings;

  SettingsUiState get currentState => state.value;

  /// Optimistic update + rollback.
  ///
  /// 1. Mevcut ayarları hemen `applyOptimistic` ile günceller (UI anında
  ///    tepki verir, tam bir SharedPreferences taraması beklenmez).
  /// 2. Persist işlemi arka planda çalışır.
  /// 3. Başarısız olursa önceki değere geri döner ve hata gösterir.
  ///    Başarılı olursa hiçbir şey yapılmaz — optimistic state zaten doğru.
  Future<void> _save({
    required String key,
    required dynamic value,
    required AppSettings Function(AppSettings current) applyOptimistic,
  }) async {
    final previous = _currentSettings;
    if (previous == null) return;

    final optimistic = applyOptimistic(previous);
    state.value = state.value.copyWith(settings: optimistic, clearError: true);

    final result = await _saveSetting(key: key, value: value);
    result.fold(
      (failure) {
        // Rollback: iyimser güncellemeyi geri al, hatayı göster.
        state.value = state.value.copyWith(
          settings: previous,
          errorEvent: SettingsErrorEvent(failure.message),
        );
      },
      (_) {
        // Persist başarılı — optimistic state zaten doğru, ek reload gerekmiyor.
      },
    );
  }

  void dispose() => state.dispose();
}
