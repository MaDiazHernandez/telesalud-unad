import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/core/services/storage_service.dart';
import 'package:frontend/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await StorageService().init();
  ApiService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Telesalud UNAD',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthenticationWrapper(),
        routes: AppRoutes.getRoutes(),
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
        // Show loading while checking authentication
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If authenticated, navigate to appropriate dashboard
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

        // Not authenticated, show login
        return const LoginScreen();
      },
    );
  }
}