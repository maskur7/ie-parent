import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'plan_channel',
      'Rencana Belajar',
      channelDescription: 'Pengingat Rencana Belajar Anak',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'plan_channel',
      'Rencana Belajar',
      channelDescription: 'Pengingat otomatis untuk rencana belajar anak',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      const NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
