// ── notification_service.dart ──────────────────────────────────────────────

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> requestPermission();

  Future<void> showCriticalStockNotification({
    required String productName,
    required double threshold,
  });

  Future<void> scheduleDailySummary({required bool enabled});
  Future<void> scheduleProductionForecast({required bool enabled});
  Future<void> cancelAll();

  Future<void> applySettings({
    required bool criticalStockNotification,
    required bool dailySummary,
    required bool productionForecast,
  });

  /// Bildirime tıklanınca dışarıya (UI katmanına) sinyal verir.
  /// main.dart'ta bir GlobalKey<NavigatorState> ile dinlenip
  /// ilgili sayfaya yönlendirme yapılabilir.
  Stream<NotificationResponse> get onNotificationTap;
}
