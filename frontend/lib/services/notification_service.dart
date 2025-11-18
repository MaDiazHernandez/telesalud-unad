// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Temporalmente deshabilitado para web - Firebase Messaging requiere configuración adicional

class NotificationService {
  // Temporalmente deshabilitado para web
  Future<void> initialize() async {
    print('⚠️ NotificationService: Deshabilitado temporalmente en web');
    // Las notificaciones están deshabilitadas en web hasta configurar el service worker
    return;
  }

  // Función para obtener el token de FCM para enviarlo al backend
  Future<String?> getFCMToken() async {
    print('⚠️ FCM Token: No disponible en web sin configuración');
    return null;
  }
}
