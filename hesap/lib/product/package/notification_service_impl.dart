import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hesap/module/notification/notification_type.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../module/notification/notification_service.dart';

final class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  final _tapController = StreamController<NotificationResponse>.broadcast();

  @override
  Stream<NotificationResponse> get onNotificationTap => _tapController.stream;

  // ── Kurulum ─────────────────────────────────────────────────────────────

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
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _tapController.add,
      );
      await _createChannels();
    } catch (e, st) {
      _logError('init', e, st);
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    } catch (e, st) {
      _logError('requestPermission', e, st);
    }
  }

  // ── Bildirimler ─────────────────────────────────────────────────────────

  @override
  Future<void> showCriticalStockNotification({
    required String productName,
    required double threshold,
  }) async {
    const type = NotificationType.criticalStock;
    try {
      await _plugin.show(
        id: type.id,
        title: '⚠️ Kritik Stok Uyarısı',
        body: '$productName stoku %${threshold.toStringAsFixed(0)} '
            'eşiğinin altına düştü!',
        notificationDetails: type.detailsWith(),
      );
    } catch (e, st) {
      _logError('showCriticalStockNotification', e, st);
    }
  }

  @override
  Future<void> scheduleDailySummary({required bool enabled}) => _schedule(
        type: NotificationType.dailySummary,
        enabled: enabled,
        hour: 8,
        minute: 0,
        title: '📊 Günlük Stok Özeti',
        body: "Bugünün stok durumunu gözden geçir.",
      );

  @override
  Future<void> scheduleProductionForecast({required bool enabled}) => _schedule(
        type: NotificationType.productionForecast,
        enabled: enabled,
        hour: 20,
        minute: 0,
        title: '🏭 Üretim Tahmini',
        body: 'Yarın için tahmini stok tüketimi hazır.',
      );

  Future<void> _schedule({
    required NotificationType type,
    required bool enabled,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      if (!enabled) {
        await _plugin.cancel(id: type.id);
        return;
      }
      await _plugin.zonedSchedule(
        id: type.id,
        title: title,
        body: body,
        scheduledDate: _nextInstanceOf(hour: hour, minute: minute),
        notificationDetails: type.detailsWith(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, st) {
      _logError('_schedule(${type.name})', e, st);
    }
  }

  @override
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e, st) {
      _logError('cancelAll', e, st);
    }
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
      await _plugin.cancel(id: NotificationType.criticalStock.id);
    }
  }

  // ── Yardımcılar ─────────────────────────────────────────────────────────

  Future<void> _createChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    for (final type in NotificationType.values) {
      await androidPlugin?.createNotificationChannel(type.androidChannel);
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

  void _logError(String context, Object error, StackTrace st) {
    debugPrint('[NotificationService] $context failed: $error\n$st');
  }

  void dispose() => _tapController.close();
}
