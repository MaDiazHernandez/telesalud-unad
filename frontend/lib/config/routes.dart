import 'package:flutter/material.dart';

// ===== AUTH =====
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// ===== DASHBOARDS =====
import '../screens/dashboard/patient_dashboard.dart';
import '../screens/dashboard/doctor_dashboard.dart';
import '../screens/dashboard/admin_dashboard.dart';

// ===== APPOINTMENTS =====
import '../screens/appointments/appointments_list_screen.dart';
import '../screens/appointments/appointment_detail_screen.dart';
import '../screens/appointments/create_appointment_screen.dart';

// ===== CONSULTATIONS =====
import '../screens/consultations/video_call_screen.dart';

// ===== PROFILE =====
import '../screens/profile/profile_screen.dart';

// ===== CHAT =====
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/chat_screen.dart';

// ===== NOTIFICATIONS =====
import '../screens/notifications/notifications_screen.dart';

// ===== MEDICAL HISTORY =====
import '../screens/medical_history/medical_history_screen.dart';

class AppRoutes {
  // ===== Rutas existentes =====
  static const String login = '/login';
  static const String register = '/register';
  static const String patientDashboard = '/patient-dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  static const String appointments = '/appointments';
  static const String appointmentDetail = '/appointment-detail';
  static const String createAppointment = '/create-appointment';

  static const String videoCall = '/video-call';
  static const String profile = '/profile';

  // ===== Nuevas rutas del chat =====
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
  
  // ===== Ruta de notificaciones =====
  static const String notifications = '/notifications';
  
  // ===== Ruta de historia clínica =====
  static const String medicalHistory = '/medical-history';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // ===== AUTH =====
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),

      // ===== DASHBOARDS =====
      patientDashboard: (context) => const PatientDashboard(),
      doctorDashboard: (context) => const DoctorDashboard(),
      adminDashboard: (context) => const AdminDashboard(),

      // ===== APPOINTMENTS =====
      appointments: (context) => const AppointmentsListScreen(),
      appointmentDetail: (context) => const AppointmentDetailScreen(),
      createAppointment: (context) => const CreateAppointmentScreen(),

      // ===== CONSULTATIONS =====
      videoCall: (context) => const VideoCallScreen(),

      // ===== PROFILE =====
      profile: (context) => const ProfileScreen(),

      // ===== CHAT =====
      chatList: (context) => const ChatListScreen(),
      chat: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        return ChatScreen(
          chatId: args['chatId']!,
          otherId: args['otherId']!,
        );
      },
      
      // ===== NOTIFICATIONS =====
      notifications: (context) => const NotificationsScreen(),
      
      // ===== MEDICAL HISTORY =====
      medicalHistory: (context) => const MedicalHistoryScreen(),
    };
  }
}
