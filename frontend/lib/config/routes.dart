import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/patient_dashboard.dart';
import '../screens/dashboard/doctor_dashboard.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/appointments/appointments_list_screen.dart';
import '../screens/appointments/appointment_detail_screen.dart';
import '../screens/appointments/create_appointment_screen.dart';
import '../screens/consultations/video_call_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
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

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      patientDashboard: (context) => const PatientDashboard(),
      doctorDashboard: (context) => const DoctorDashboard(),
      adminDashboard: (context) => const AdminDashboard(),
      appointments: (context) => const AppointmentsListScreen(),
      appointmentDetail: (context) => const AppointmentDetailScreen(),
      createAppointment: (context) => const CreateAppointmentScreen(),
      videoCall: (context) => const VideoCallScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
