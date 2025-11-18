import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationManager {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);
  }

  static Future<void> showSimpleNotification(
      String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "telesalud_channel",
      "Telesalud Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
