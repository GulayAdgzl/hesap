abstract interface class RemoteConfigAbstraction {
  Future<void> fetchAndActivate();

  String getString(String key);

  bool getBool(String key);

  int getInt(String key);
}
