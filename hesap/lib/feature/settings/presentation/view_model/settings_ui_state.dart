import '../../domain/entities/app_settings.dart';

/// Her oluşturulduğunda kendine özgü bir kimliğe sahip, tek seferlik hata
/// olayı. Aynı mesaj metni tekrar gelse bile (`identical` ile) farklı bir
/// event olarak ayırt edilir — bu da UI tarafının "bu event'i daha önce
/// gösterdim mi" diye state'e geri yazmadan, kendi içinde takip edebilmesini
/// sağlar.
final class SettingsErrorEvent {
  const SettingsErrorEvent(this.message);
  final String message;
}

final class SettingsUiState {
  final bool isLoading;
  final AppSettings? settings;
  final SettingsErrorEvent? errorEvent;

  const SettingsUiState({
    this.isLoading = false,
    this.settings,
    this.errorEvent,
  });

  /// İlk durum: yükleme başlamadan önce.
  const SettingsUiState.initial()
      : isLoading = false,
        settings = null,
        errorEvent = null;

  bool get hasError => errorEvent != null;
  bool get hasSettings => settings != null;

  /// Geriye dönük uyumluluk / kolay okuma için düz mesaj erişimi.
  String? get error => errorEvent?.message;

  SettingsUiState copyWith({
    bool? isLoading,
    AppSettings? settings,
    SettingsErrorEvent? errorEvent,
    bool clearError = false,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      errorEvent: clearError ? null : (errorEvent ?? this.errorEvent),
    );
  }
}
