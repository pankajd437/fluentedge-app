import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _timeZoneInitialized = false;

  /// 🔁 Initialize notification service with permissions
  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);

    if (!_timeZoneInitialized) {
      tz.initializeTimeZones();
      _timeZoneInitialized = true;
    }

    await _requestNotificationPermission();
    await _requestExactAlarmPermission();
  }

  /// 🔐 Android 13+: Request notification permission
  static Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        print("❌ Notification permission denied.");
      }
    }
  }

  /// ⏰ Android 12+: Request schedule exact alarm permission
  static Future<void> _requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();

      if (!result.isGranted) {
        print("⚠️ Exact alarm permission still denied. Opening settings...");

        // 🧭 Open exact alarm settings screen
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
      }
    }
  }

  /// 🔔 Daily 8 PM streak reminder
  static Future<void> scheduleDailyReminder() async {
    final notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      print("⏸️ Skipping reminder - notification permission not granted.");
      return;
    }

    final alarmStatus = await Permission.scheduleExactAlarm.status;
    if (!alarmStatus.isGranted) {
      print("⏸️ Skipping reminder - exact alarm permission not granted.");
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      '🔥 Don’t lose your streak!',
      'Open FluentEdge and continue your progress 🧠',
      _next8PM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          channelDescription: 'Daily streak reminder for FluentEdge',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 🧪 Test notification (after 5 seconds)
  static Future<void> testNowNotification() async {
    final notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      print("⚠️ Cannot show test notification - permission not granted.");
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      1,
      '🧪 Test Notification',
      'This is a test push to confirm it works!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          channelDescription: 'Used for testing notification display',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 🕗 Calculate the next 8 PM local time
  static tz.TZDateTime _next8PM() {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    return now.isAfter(scheduled)
        ? scheduled.add(const Duration(days: 1))
        : scheduled;
  }
}
