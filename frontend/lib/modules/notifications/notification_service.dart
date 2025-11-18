import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _fcm.requestPermission();

    // Token del dispositivo
    final token = await _fcm.getToken();
    print("FCM TOKEN: $token");

    FirebaseMessaging.onMessage.listen((message) {
      print("NOTIFICACIÓN RECIBIDA: ${message.notification?.title}");
    });
  }
}
