import 'dart:convert';
import 'package:frontend/config/constants.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/core/services/storage_service.dart';
import 'package:frontend/models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _api = ApiService();
  final _storage = StorageService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Login - Adaptado al backend real
  Future<User> login(String email, String password, {bool rememberMe = false}) async {
    try {
      print('🔐 Intentando login con: $email');
      
      final response = await _api.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('✅ Respuesta del backend: ${response.data}');
      print('✅ Status code: ${response.statusCode}');

      // Backend devuelve: { success, message, data: { usuario, token } }
      if (response.data['success'] == true && response.data['data'] != null) {
        final token = response.data['data']['token'];
        final userData = response.data['data']['usuario'];

        print('✅ Token recibido: ${token.substring(0, 20)}...');
        print('✅ Usuario recibido: ${userData['email']}');

        // Save token securely
        await _storage.saveSecure(AppConstants.tokenKey, token);
        
        // Save user data
        await _storage.saveObject(AppConstants.userKey, userData);
        
        // Save remember me preference
        await _storage.saveBool(AppConstants.rememberMeKey, rememberMe);

        _currentUser = User.fromJson(userData);
        print('✅ Login exitoso para: ${_currentUser!.fullName}');
        return _currentUser!;
      } else {
        throw Exception(response.data['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      print('❌ Error completo en login: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      rethrow; // Re-lanzar el error original
    }
  }

  // Register - Adaptado al backend real
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String identificationType,
    required String identificationNumber,
    required String phone,
    required String role,
    String? address,
    DateTime? birthDate,
  }) async {
    try {
      print('📝 Intentando registro con: $email');
      
      final response = await _api.post(
        AppConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'nombre': firstName, // Backend usa 'nombre'
          'apellido': lastName, // Backend usa 'apellido'
          'documento': identificationNumber, // Backend usa 'documento'
          'telefono': phone, // Backend usa 'telefono'
          'rol': role, // Backend usa 'rol'
        },
      );

      print('✅ Respuesta del registro: ${response.data}');

      // Backend devuelve: { success, message, data: { usuario, token } }
      if (response.data['success'] == true && response.data['data'] != null) {
        final token = response.data['data']['token'];
        final userData = response.data['data']['usuario'];

        // Save token securely
        await _storage.saveSecure(AppConstants.tokenKey, token);
        
        // Save user data
        await _storage.saveObject(AppConstants.userKey, userData);

        _currentUser = User.fromJson(userData);
        print('✅ Registro exitoso para: ${_currentUser!.fullName}');
        return _currentUser!;
      } else {
        throw Exception(response.data['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      throw Exception('Error al registrarse: $e');
    }
  }

  // Get current user profile - Adaptado al backend real
  Future<User> getProfile() async {
    try {
      print('👤 Obteniendo perfil...');
      
      final response = await _api.get(AppConstants.profileEndpoint);
      
      print('✅ Respuesta del perfil: ${response.data}');

      // Backend devuelve: { success, data: usuario }
      if (response.data['success'] == true && response.data['data'] != null) {
        final userData = response.data['data'];
        
        // Update stored user data
        await _storage.saveObject(AppConstants.userKey, userData);
        
        _currentUser = User.fromJson(userData);
        print('✅ Perfil obtenido: ${_currentUser!.fullName}');
        return _currentUser!;
      } else {
        throw Exception(response.data['message'] ?? 'Error al obtener perfil');
      }
    } catch (e) {
      print('❌ Error al obtener perfil: $e');
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // Update profile
  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      print('✏️ Actualizando perfil...');
      
      final response = await _api.put(
        AppConstants.profileEndpoint,
        data: data,
      );
      
      final userData = response.data['data'];
      
      // Update stored user data
      await _storage.saveObject(AppConstants.userKey, userData);
      
      _currentUser = User.fromJson(userData);
      return _currentUser!;
    } catch (e) {
      print('❌ Error al actualizar perfil: $e');
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _api.post(
        '${AppConstants.profileEndpoint}/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Error al cambiar contraseña: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      print('👋 Cerrando sesión...');
      // Clear all stored data
      await _storage.clearSecure();
      await _storage.remove(AppConstants.userKey);
      _currentUser = null;
      print('✅ Sesión cerrada');
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.getSecure(AppConstants.tokenKey);
    print('🔑 Token existe: ${token != null}');
    return token != null;
  }

  // Load user from storage
  Future<User?> loadUser() async {
    final userData = _storage.getObject(AppConstants.userKey);
    if (userData != null) {
      _currentUser = User.fromJson(userData);
      print('✅ Usuario cargado del storage: ${_currentUser!.fullName}');
      return _currentUser;
    }
    print('❌ No hay usuario en storage');
    return null;
  }

  // Check if should remember user
  bool shouldRememberUser() {
    return _storage.getBool(AppConstants.rememberMeKey) ?? false;
  }
}