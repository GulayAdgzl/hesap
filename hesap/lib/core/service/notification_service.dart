import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Notification IDs
  static const int idCriticalStock = 1001;
  static const int idDailySummary = 1002;
  static const int idProductionForecast = 1003;

  // Channel IDs
  static const String channelCriticalStock = 'critical_stock';
  static const String channelDailySummary = 'daily_summary';
  static const String channelProductionForecast = 'production_forecast';

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createChannels();
  }

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

  // ── Kritik Stok Bildirimi ────────────────────────────────────────────────

  Future<void> showCriticalStockNotification({
    required String productName,
    required double threshold,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelCriticalStock,
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
      id: idCriticalStock,
      title: '⚠️ Kritik Stok Uyarısı',
      body:
          '$productName stoku %${threshold.toStringAsFixed(0)} eşiğinin altına düştü!',
      notificationDetails: details,
    );
  }

  // ── Günlük Özet — Her Sabah 08:00 ────────────────────────────────────────

  Future<void> scheduleDailySummary({required bool enabled}) async {
    if (!enabled) {
      await _plugin.cancel(id: idDailySummary);
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelDailySummary,
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
      id: idDailySummary,
      title: '📊 Günlük Stok Özeti',
      body: 'Bugünün stok durumunu gözden geçir.',
      scheduledDate: _nextInstanceOf(hour: 8, minute: 0),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── Üretim Tahmini — Her Akşam 20:00 ─────────────────────────────────────

  Future<void> scheduleProductionForecast({required bool enabled}) async {
    if (!enabled) {
      await _plugin.cancel(id: idProductionForecast);
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelProductionForecast,
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
      id: idProductionForecast,
      title: '🏭 Üretim Tahmini',
      body: 'Yarın için tahmini stok tüketimi hazır.',
      scheduledDate: _nextInstanceOf(hour: 20, minute: 0),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── Tüm Bildirimleri İptal Et (logout) ───────────────────────────────────

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Ayar Değişikliklerini Uygula ─────────────────────────────────────────

  Future<void> applySettings({
    required bool criticalStockNotification,
    required bool dailySummary,
    required bool productionForecast,
  }) async {
    await scheduleDailySummary(enabled: dailySummary);
    await scheduleProductionForecast(enabled: productionForecast);
    if (!criticalStockNotification) {
      await _plugin.cancel(id: idCriticalStock);
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _createChannels() async {
    const channels = [
      AndroidNotificationChannel(
        channelCriticalStock,
        'Kritik Stok',
        description: 'Stok kritik seviyeye düştüğünde bildirim',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        channelDailySummary,
        'Günlük Özet',
        description: 'Her sabah 08:00\'de günlük stok özeti',
        importance: Importance.defaultImportance,
      ),
      AndroidNotificationChannel(
        channelProductionForecast,
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
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Bildirime tıklanınca yapılacak işlemler buraya eklenebilir
  }
}
