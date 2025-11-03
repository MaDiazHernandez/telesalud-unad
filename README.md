# 🏥 Telesalud - Sistema Digital de Atención Médica a Distancia

Sistema de telemedicina desarrollado para facilitar el acceso a servicios de salud en comunidades rurales de Colombia mediante consultas médicas virtuales, gestión de historias clínicas electrónicas y seguimiento de tratamientos.

**Proyecto de Grado - UNAD 2024**

[![Node.js](https://img.shields.io/badge/Node.js-18+-green)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-blue)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Academic-yellow)](LICENSE)

---

## 📋 Descripción

Plataforma integral de telemedicina que conecta pacientes con profesionales de la salud mediante videollamadas, permitiendo consultas remotas, gestión de citas médicas y seguimiento de tratamientos. Diseñado específicamente para mejorar el acceso a servicios de salud en zonas rurales de Colombia.

---

## 🏗️ Arquitectura
```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Flutter   │ ───▶ │  Node.js    │ ───▶ │ PostgreSQL  │
│  Frontend   │ ◀─── │   Backend   │ ◀─── │  Database   │
└─────────────┘      └─────────────┘      └─────────────┘
       │                     │
       │                     │
       ▼                     ▼
┌─────────────┐      ┌─────────────┐
│  Agora SDK  │      │  Socket.io  │
│Videollamadas│      │   Real-time │
└─────────────┘      └─────────────┘
```

**Stack Tecnológico:**
- **Frontend:** Flutter (Android, iOS, Web)
- **Backend:** Node.js + Express + Sequelize ORM
- **Base de Datos:** PostgreSQL
- **Autenticación:** JWT (JSON Web Tokens)
- **Videollamadas:** Agora SDK
- **Tiempo Real:** Socket.io

---

## 📦 Estructura del Proyecto
```
telesalud/
├── backend/              # API REST
│   ├── src/
│   │   ├── config/       # Configuración
│   │   ├── controllers/  # Lógica de negocio
│   │   ├── middlewares/  # Autenticación, validaciones
│   │   ├── models/       # Modelos Sequelize
│   │   ├── routes/       # Rutas API
│   │   └── seeders/      # Datos de prueba
│   ├── .env.example      # Variables de entorno
│   └── package.json
│
├── frontend/             # Aplicación Flutter
│   ├── lib/
│   │   ├── config/       # Configuración
│   │   ├── core/         # Servicios, utilidades
│   │   ├── models/       # Modelos de datos
│   │   ├── providers/    # Estado global
│   │   ├── screens/      # Pantallas
│   │   └── main.dart     # Entry point
│   └── pubspec.yaml
│
└── docs/                 # Documentación
    ├── api/              # Endpoints API
    ├── database/         # Esquemas BD
    └── user-manual/      # Manual de usuario
```

---

## 🚀 Características

### 👨‍⚕️ Para Profesionales de la Salud
- ✅ Gestión de agenda médica
- ✅ Consultas por videollamada
- ✅ Registro de diagnósticos y tratamientos
- ✅ Acceso a historiales clínicos
- ✅ Dashboard con estadísticas

### 👥 Para Pacientes
- ✅ Registro y gestión de perfil
- ✅ Agendamiento de citas médicas
- ✅ Consultas virtuales por video
- ✅ Historia clínica electrónica
- ✅ Notificaciones y recordatorios

### 👨‍💼 Para Administradores
- ✅ Gestión de usuarios y roles
- ✅ Reportes y estadísticas del sistema
- ✅ Monitoreo de consultas
- ✅ Auditoría y logs

---

## 📥 Instalación

### **Prerrequisitos**

- Node.js 18+ ([Descargar](https://nodejs.org/))
- PostgreSQL 14+ ([Descargar](https://www.postgresql.org/download/))
- Flutter 3.16+ ([Instalar](https://flutter.dev/docs/get-started/install))
- Git

### **1️⃣ Clonar el Repositorio**
```bash
git clone https://github.com/TU-USUARIO/telesalud-unad.git
cd telesalud-unad
```

### **2️⃣ Configurar Backend**
```bash
cd backend

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales de PostgreSQL

# Crear base de datos
psql -U postgres
CREATE DATABASE telesalud_db;
\q

# Ejecutar migraciones y datos de prueba
npm run seed

# Iniciar servidor
npm start
```

El servidor estará disponible en: `http://localhost:3000`

### **3️⃣ Configurar Frontend**
```bash
cd ../frontend

# Instalar dependencias
flutter pub get

# Configurar IP del backend (si usas dispositivo físico)
# Edita: lib/config/constants.dart

# Ejecutar aplicación
flutter run
```

---

## 🔐 Credenciales de Prueba

El sistema incluye usuarios de prueba creados con el seeding:

| Rol | Email | Contraseña |
|-----|-------|------------|
| **Administrador** | admin@telesalud.com | admin123 |
| **Médico** | juan.perez@telesalud.com | admin123 |
| **Paciente** | ana.garcia@email.com | paci123 |

> ⚠️ **Importante:** Cambiar estas credenciales en producción.

---

## 📚 Documentación API

### **Endpoints Principales**

#### **Autenticación**
```http
POST /api/auth/register    # Registro de usuario
POST /api/auth/login       # Inicio de sesión
GET  /api/auth/profile     # Obtener perfil (requiere token)
```

#### **Usuarios**
```http
GET    /api/usuarios       # Listar usuarios (admin)
GET    /api/usuarios/:id   # Obtener usuario
PUT    /api/usuarios/:id   # Actualizar usuario
DELETE /api/usuarios/:id   # Eliminar usuario (admin)
```

#### **Citas** (En desarrollo)
```http
GET  /api/citas            # Listar citas
POST /api/citas            # Crear cita
PUT  /api/citas/:id        # Actualizar cita
```

**Autenticación:**
Incluir header: `Authorization: Bearer <token>`

---

## 🧪 Testing
```bash
# Backend
cd backend
npm test

# Frontend
cd frontend
flutter test
```

---

## 🚀 Despliegue

### **Backend (Railway / Render / Heroku)**

1. Configurar variables de entorno en el servicio
2. Conectar repositorio de GitHub
3. Build command: `npm install`
4. Start command: `npm start`

### **Frontend Web (Firebase Hosting / Vercel)**
```bash
cd frontend
flutter build web
# Subir carpeta build/web/ al hosting
```

### **Frontend Mobile (Google Play / App Store)**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📊 Estado del Proyecto

| Módulo | Estado | Completado |
|--------|--------|------------|
| Autenticación JWT | ✅ Completo | 100% |
| Gestión de Usuarios | ✅ Completo | 100% |
| Dashboards por Rol | ✅ Completo | 100% |
| Sistema de Citas | 🚧 En desarrollo | 30% |
| Consultas Médicas | 🚧 En desarrollo | 20% |
| Videollamadas | 🚧 En desarrollo | 10% |
| Notificaciones | ⏳ Pendiente | 0% |
| Chat en Tiempo Real | ⏳ Pendiente | 0% |

---

## 🤝 Contribuciones

Este es un proyecto académico de la Universidad Nacional Abierta y a Distancia (UNAD). 

Si deseas contribuir:

1. Fork el proyecto
2. Crea una rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'feat: Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 👥 Equipo de Desarrollo

**Proyecto de Grado - UNAD 2024**

- **Kevin Alberto Salas López** 
- **Maria Fernanda Hernandez Diaz** 
- **Edwin Leonardo Muñoz Martínez** 

**Tutor:** Daniel Andrés Guzmán

**Programa:** Ingeniería de Sistemas  
**Universidad:** Universidad Nacional Abierta y a Distancia (UNAD)

---


## 📄 Licencia

Proyecto académico desarrollado para la Universidad Nacional Abierta y a Distancia (UNAD).

Todos los derechos reservados © 2024

---

**Desarrollado con ❤️ para mejorar el acceso a la salud en Colombia 🇨🇴**