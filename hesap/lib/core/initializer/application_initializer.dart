import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hesap/core/initializer/platform/mobile_platform_initializer.dart';
import 'package:hesap/core/initializer/platform/web_platform_initializer.dart';
import 'package:hesap/module/notification/notification_service.dart';
import 'package:hesap/product/initialize/injection_container.dart';
import 'package:hesap/product/model/daily_stock_entry_model.dart';
import 'package:hesap/product/model/product_model.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

final class ApplicationInitializer {
  ApplicationInitializer._();

  static void run() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> prepare() async {
    await _initHive(); // 1) Önce adapter'lar register edilsin (sıralı, await ile)

    await Future.wait([
      _initDependencyInjection(), // 2) Artık openBox güvenli
      _initPlatformSpecific(),
    ]);

    await _initPostDiServices();
  }
  // ─── Private Helpers ────────────────────────────────────────────────────────

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(DailyStockEntryModelAdapter());
  }

  static Future<void> _initDependencyInjection() async {
    await init(); // injection_container.dart
  }

  static Future<void> _initPlatformSpecific() async {
    final initializer = kIsWeb
        ? const WebPlatformInitializer()
        : const MobilePlatformInitializer();
    await initializer.initialize();
  }

  static Future<void> _initPostDiServices() async {
    final notificationService = sl<NotificationService>();
    await Future.wait([
      notificationService.init(),
      notificationService.requestPermission(),
    ]);
  }
}
