import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../module/notification/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _idCriticalStock = 1001;
  static const int _idDailySummary = 1002;
  static const int _idProductionForecast = 1003;

  static const String _channelCriticalStock = 'critical_stock';
  static const String _channelDailySummary = 'daily_summary';
  static const String _channelProductionForecast = 'production_forecast';

  @override
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createChannels();
  }

  @override
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> showCriticalStockNotification({
    required String productName,
    required double threshold,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelCriticalStock,
        'Kritik Stok',
        channelDescription: 'Stok kritik seviyeye düştüğünde bildirim',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      id: _idCriticalStock,
      title: '⚠️ Kritik Stok Uyarısı',
      body:
          '$productName stoku %${threshold.toStringAsFixed(0)} eşiğinin altına düştü!',
      notificationDetails: details,
    );
  }

  @override
  Future<void> scheduleDailySummary({required bool enabled}) async {
    if (!enabled) {
      await _plugin.cancel(id: _idDailySummary);
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelDailySummary,
        'Günlük Özet',
        channelDescription: 'Her sabah 08:00\'de günlük stok özeti',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
    );

    await _plugin.zonedSchedule(
      id: _idDailySummary,
      title: '📊 Günlük Stok Özeti',
      body: 'Bugünün stok durumunu gözden geçir.',
      scheduledDate: _nextInstanceOf(hour: 8, minute: 0),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> scheduleProductionForecast({required bool enabled}) async {
    if (!enabled) {
      await _plugin.cancel(id: _idProductionForecast);
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelProductionForecast,
        'Üretim Tahmini',
        channelDescription: 'Yarın için üretim tahmini bildirimi',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
    );

    await _plugin.zonedSchedule(
      id: _idProductionForecast,
      title: '🏭 Üretim Tahmini',
      body: 'Yarın için tahmini stok tüketimi hazır.',
      scheduledDate: _nextInstanceOf(hour: 20, minute: 0),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  @override
  Future<void> applySettings({
    required bool criticalStockNotification,
    required bool dailySummary,
    required bool productionForecast,
  }) async {
    await scheduleDailySummary(enabled: dailySummary);
    await scheduleProductionForecast(enabled: productionForecast);
    if (!criticalStockNotification) {
      await _plugin.cancel(id: _idCriticalStock);
    }
  }

  Future<void> _createChannels() async {
    const channels = [
      AndroidNotificationChannel(
        _channelCriticalStock,
        'Kritik Stok',
        description: 'Stok kritik seviyeye düştüğünde bildirim',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        _channelDailySummary,
        'Günlük Özet',
        description: 'Her sabah 08:00\'de günlük stok özeti',
        importance: Importance.defaultImportance,
      ),
      AndroidNotificationChannel(
        _channelProductionForecast,
        'Üretim Tahmini',
        description: 'Yarın için üretim tahmini bildirimi',
        importance: Importance.defaultImportance,
      ),
    ];

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    for (final channel in channels) {
      await androidPlugin?.createNotificationChannel(channel);
    }
  }

  tz.TZDateTime _nextInstanceOf({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  void _onNotificationTap(NotificationResponse response) {}
}
