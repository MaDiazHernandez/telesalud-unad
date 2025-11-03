# 📱 Frontend Flutter - Sistema Telesalud UNAD

## 🎯 Archivos Creados

He creado los archivos base del frontend Flutter con la siguiente estructura:

### 📁 Estructura de archivos

```
lib/
├── main.dart                           ✅ Punto de entrada de la app
├── config/
│   ├── constants.dart                  ✅ Constantes y configuración
│   └── theme.dart                      ✅ Tema y estilos
├── core/
│   └── services/
│       ├── api_service.dart            ✅ Cliente HTTP con Dio
│       ├── auth_service.dart           ✅ Servicio de autenticación
│       └── storage_service.dart        ✅ Almacenamiento local seguro
├── models/
│   ├── user.dart                       ✅ Modelo de usuario
│   └── appointment.dart                ✅ Modelo de cita
├── providers/
│   └── auth_provider.dart              ✅ Estado de autenticación
└── screens/
    └── auth/
        └── login_screen.dart           ✅ Pantalla de login
```

---

## 📦 Paso 1: Organizar los archivos

Copia los archivos descargados a tu proyecto Flutter en esta estructura:

```
C:\Users\miche\telesalud\frontend\lib\
├── main.dart
├── config\
│   ├── constants.dart
│   └── theme.dart
├── core\
│   └── services\
│       ├── api_service.dart
│       ├── auth_service.dart
│       └── storage_service.dart
├── models\
│   ├── user.dart
│   └── appointment.dart
├── providers\
│   └── auth_provider.dart
└── screens\
    └── auth\
        └── login_screen.dart
```

### Comandos para crear las carpetas (en CMD):

```cmd
cd C:\Users\miche\telesalud\frontend\lib
mkdir config
mkdir core\services
mkdir models
mkdir providers
mkdir screens\auth
mkdir screens\dashboard
mkdir widgets
```

Luego copia cada archivo a su carpeta correspondiente.

---

## ⚙️ Paso 2: Configurar la URL de tu backend

Edita el archivo `lib/config/constants.dart` y cambia la URL del backend:

```dart
// Si tu backend está en localhost
static const String baseUrl = 'http://localhost:3000/api';
static const String socketUrl = 'http://localhost:3000';

// O si usas la IP de tu computadora (para probar en dispositivo móvil)
static const String baseUrl = 'http://192.168.1.X:3000/api';  // Cambia X por tu IP
static const String socketUrl = 'http://192.168.1.X:3000';
```

---

## 🚀 Paso 3: Ejecutar la aplicación

### Opción 1: Android Emulator

```cmd
cd C:\Users\miche\telesalud\frontend
flutter run
```

### Opción 2: Navegador Web

```cmd
flutter run -d chrome
```

### Opción 3: Dispositivo físico conectado

```cmd
flutter devices
flutter run -d <device-id>
```

---

## 🧪 Paso 4: Probar la aplicación

### Credenciales de prueba:

**Administrador:**
- Email: `admin@telesalud.com`
- Password: `Admin123`

**Médico:**
- Email: `doctor@telesalud.com`
- Password: `Doctor123`

**Paciente:**
- Email: `juan.perez@email.com`
- Password: `Paciente123`

---

## 📝 Próximos Pasos

### Archivos que aún faltan por crear:

1. **Pantalla de Registro** (`register_screen.dart`)
2. **Dashboards por Rol:**
   - `patient_dashboard.dart`
   - `doctor_dashboard.dart`
   - `admin_dashboard.dart`
3. **Gestión de Citas:**
   - `appointments_list_screen.dart`
   - `appointment_detail_screen.dart`
   - `create_appointment_screen.dart`
4. **Videollamadas:**
   - `video_call_screen.dart`
5. **Perfil:**
   - `profile_screen.dart`
6. **Widgets reutilizables:**
   - `custom_button.dart`
   - `custom_text_field.dart`
   - `loading_indicator.dart`

---

## 🛠️ Características Implementadas

### ✅ Servicios Core
- **API Service**: Cliente HTTP con Dio, interceptores, manejo de errores
- **Auth Service**: Login, registro, gestión de sesión, tokens
- **Storage Service**: Almacenamiento seguro (tokens) y normal (preferencias)

### ✅ Estado Global
- **Auth Provider**: Gestión de estado de autenticación con Provider

### ✅ Modelos
- **User**: Modelo completo de usuario con roles
- **Appointment**: Modelo de citas médicas

### ✅ UI/UX
- **Tema personalizado**: Colores, estilos, componentes
- **Login Screen**: Pantalla completa con validación

---

## 🔧 Configuración Adicional

### Android - Permisos (android/app/src/main/AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### iOS - Permisos (ios/Runner/Info.plist):

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para videollamadas</string>
<key>NSMicrophoneUsageDescription</key>
<string>Necesitamos acceso al micrófono para videollamadas</string>
```

---

## 📚 Dependencias Instaladas

Ya instalaste estas dependencias:
- ✅ `dio` - Cliente HTTP
- ✅ `provider` - Gestión de estado
- ✅ `shared_preferences` - Almacenamiento local
- ✅ `flutter_secure_storage` - Almacenamiento seguro
- ✅ `socket_io_client` - WebSockets
- ✅ `agora_rtc_engine` - Videollamadas
- ✅ `permission_handler` - Permisos
- ✅ `image_picker` - Selección de imágenes
- ✅ `intl` - Formateo de fechas

---

## 🐛 Solución de Problemas

### Error: "Cannot find package"
```cmd
flutter pub get
```

### Error: "Gradle build failed"
```cmd
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error de conexión al backend
- Verifica que el backend esté ejecutándose en `http://localhost:3000`
- Si pruebas en dispositivo físico, usa la IP de tu computadora

---

## 📞 Contacto

**Proyecto de Grado - UNAD 2024**

- Kevin Alberto Salas López
- Maria Fernanda Hernandez Diaz
- Edwin Leonardo Muñoz Martínez

---

## ✨ Estado del Proyecto

### ✅ Completado
- Configuración inicial del proyecto
- Servicios core (API, Auth, Storage)
- Modelos básicos (User, Appointment)
- Pantalla de login
- Tema y estilos

### 🚧 En Desarrollo
- Dashboards por rol
- Gestión de citas
- Videollamadas
- Perfil de usuario
- Notificaciones

### 📋 Por Hacer
- Historial clínico
- Chat en tiempo real
- Reportes y estadísticas
- Tests unitarios
- Documentación API

---

**Desarrollado con ❤️ para mejorar el acceso a la salud en Colombia**
