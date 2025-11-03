import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // ✅ Auto-detect backend base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      // 🖥️ Flutter Web: usa la IP local de tu PC (REEMPLAZADA con la tuya)
      return 'http://192.168.18.144:3000/api';
    } else if (Platform.isAndroid) {
      // 📱 Android Emulator: localhost es 10.0.2.2
      return 'http://10.0.2.2:3000/api';
    } else {
      // 🖥️ Escritorio: localhost directo (si tienes backend corriendo ahí)
      return 'http://localhost:3000/api';
    }
  }

  // ✅ WebSockets o sockets IO
  static String get socketUrl {
    if (kIsWeb) {
      return 'http://192.168.18.144:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // 🔗 API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/auth/profile';
  static const String appointmentsEndpoint = '/appointments';
  static const String consultationsEndpoint = '/consultations';
  static const String patientsEndpoint = '/patients';
  static const String usersEndpoint = '/usuarios';
  static const String notificationsEndpoint = '/notifications';

  // 🔐 Storage Keys (para usar con SharedPreferences o SecureStorage)
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';

  // 👤 User Roles
  static const String roleAdmin = 'administrador';
  static const String roleDoctor = 'profesional';
  static const String rolePatient = 'paciente';

  // 📅 Estados de Citas Médicas
  static const String appointmentPending = 'pendiente';
  static const String appointmentConfirmed = 'confirmada';
  static const String appointmentCompleted = 'completada';
  static const String appointmentCancelled = 'cancelada';

  // 📹 Estados de Consultas
  static const String consultationScheduled = 'programada';
  static const String consultationInProgress = 'en_progreso';
  static const String consultationCompleted = 'completada';
  static const String consultationCancelled = 'cancelada';

  // 📹 (Opcional) Configuración de Agora para video llamadas
  static const String agoraAppId = 'YOUR_AGORA_APP_ID';

  // 📅 Formatos de fechas
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // 📄 Paginación
  static const int defaultPageSize = 10;

  // ⏳ Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration socketTimeout = Duration(seconds: 10);
}