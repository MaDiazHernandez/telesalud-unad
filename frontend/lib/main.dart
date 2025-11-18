import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Configuración
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/routes.dart';

// Providers
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/core/services/storage_service.dart';

// Pantallas
import 'package:frontend/screens/auth/login_screen.dart';

// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Chat Provider ✔
import 'package:frontend/providers/chat_provider.dart';
import 'package:frontend/services/notification_service.dart';
import 'package:frontend/services/socket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar servicios de tu app
  await StorageService().init();
  ApiService().init();

  // Inicializar servicios de Notificaciones y Socket
  // NOTA: Las notificaciones en web requieren configuración adicional de service worker
  if (!kIsWeb) {
    await NotificationService().initialize();
  }
  final socketService = SocketService();
  
  // Registrar el servicio de Socket en GetIt si lo usas, o pasarlo a los providers
  // Si no usas GetIt, lo inyectaremos en MultiProvider.

  runApp(MyApp(socketService: socketService));



}

class MyApp extends StatelessWidget {
  final SocketService socketService;
  const MyApp({super.key, required this.socketService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()), // <-- AÑADIDO ✔
        ChangeNotifierProvider.value(value: socketService),
      ],
      child: MaterialApp(
        title: 'Telesalud UNAD',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthenticationWrapper(),
        routes: AppRoutes.getRoutes(), // <-- Tus rutas + la de chat ✔
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuth();

    if (mounted && authProvider.isAuthenticated) {
      _navigateToDashboard(authProvider.user!.rol);
    }
  }

  void _navigateToDashboard(String role) {
    String route;

    switch (role) {
      case 'administrador':
        route = AppRoutes.adminDashboard;
        break;
      case 'profesional':
        route = AppRoutes.doctorDashboard;
        break;
      case 'paciente':
      default:
        route = AppRoutes.patientDashboard;
        break;
    }

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated && authProvider.user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToDashboard(authProvider.user!.rol);
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
