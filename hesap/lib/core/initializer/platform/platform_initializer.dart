abstract interface class PlatformInitializer {
  const PlatformInitializer();

  Future<void> initialize();
}
