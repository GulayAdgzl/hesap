/*
import 'package:hesap/core/remote_config/remote_config_abstraction.dart';


final class CustomRemoteConfig implements RemoteConfigAbstraction {
  CustomRemoteConfig._(this._config);

  final FirebaseRemoteConfig _config;

  /// Singleton factory — DI'a register edilebilir.
  static Future<CustomRemoteConfig> create() async {
    final config = FirebaseRemoteConfig.instance;
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    return CustomRemoteConfig._(config);
  }

  @override
  Future<void> fetchAndActivate() => _config.fetchAndActivate();

  @override
  String getString(String key) => _config.getString(key);

  @override
  bool getBool(String key) => _config.getBool(key);

  @override
  int getInt(String key) => _config.getInt(key);
}*/
