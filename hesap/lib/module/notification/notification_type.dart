import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationType {
  criticalStock(
    id: 1001,
    channelId: 'critical_stock',
    channelName: 'Kritik Stok',
    channelDescription: 'Stok kritik seviyeye düştüğünde bildirim',
    importance: Importance.high,
    priority: Priority.high,
  ),
  dailySummary(
    id: 1002,
    channelId: 'daily_summary',
    channelName: 'Günlük Özet',
    channelDescription: "Her sabah 08:00'de günlük stok özeti",
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  ),
  productionForecast(
    id: 1003,
    channelId: 'production_forecast',
    channelName: 'Üretim Tahmini',
    channelDescription: 'Yarın için üretim tahmini bildirimi',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  const NotificationType({
    required this.id,
    required this.channelId,
    required this.channelName,
    required this.channelDescription,
    required this.importance,
    required this.priority,
  });

  final int id;
  final String channelId;
  final String channelName;
  final String channelDescription;
  final Importance importance;
  final Priority priority;

  AndroidNotificationChannel get androidChannel => AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: importance,
      );

  NotificationDetails detailsWith({bool silent = false}) => NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: importance,
          priority: priority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: this == NotificationType.criticalStock,
          presentSound: !silent,
        ),
      );
}
