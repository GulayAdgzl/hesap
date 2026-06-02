final class EnvironmentManager {
  EnvironmentManager._();

  static const String _rawEnv =
      String.fromEnvironment('ENV', defaultValue: 'development');
  static const String _apiKey =
      String.fromEnvironment('API_KEY', defaultValue: '');
  static const String _baseUrl = String.fromEnvironment('BASE_URL',
      defaultValue: 'https://dev.example.com');

  static AppEnvironment get current => switch (_rawEnv) {
        'production' => AppEnvironment.production,
        'staging' => AppEnvironment.staging,
        _ => AppEnvironment.development,
      };

  static bool get isProduction => current == AppEnvironment.production;
  static bool get isStaging => current == AppEnvironment.staging;
  static bool get isDevelopment => current == AppEnvironment.development;

  static String get apiKey {
    assert(_apiKey.isNotEmpty, 'API_KEY dart-define ile sağlanmadı!');
    return _apiKey;
  }

  static String get baseUrl => _baseUrl;
}

enum AppEnvironment { development, staging, production }
