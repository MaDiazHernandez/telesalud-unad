\# Backend - Telesalud



API REST para el Sistema de Telemedicina



\## 🚀 Tecnologías



\- Node.js 18+

\- Express.js

\- PostgreSQL

\- Sequelize ORM

\- JWT



\## 📦 Instalación

```bash

npm install

```



\## ⚙️ Configuración



1\. Crear archivo `.env` basado en `.env.example`

2\. Configurar PostgreSQL

3\. Crear base de datos: `telesalud\_db`



\## 🗄️ Base de Datos



\### Crear base de datos en PostgreSQL:

```sql

CREATE DATABASE telesalud\_db;

```



\### Cargar datos iniciales:

```bash

npm run seed

```



Esto creará:

\- ✅ 2 Administradores

\- ✅ 3 Pacientes



\### Usuarios precargados (password: admin123):



\*\*Administradores:\*\*

\- admin@telesalud.com

\- supervisor@telesalud.com



\*\*Pacientes:\*\*

\- juan.perez@email.com

\- ana.garcia@email.com

\- pedro.martinez@email.com



\## 🏃 Ejecutar

```bash

\# Desarrollo

npm run dev



\# Producción

npm start

```



\## 📡 Endpoints



\### Auth

\- POST `/api/auth/register` - Registrar usuario

\- POST `/api/auth/login` - Iniciar sesión

\- GET `/api/auth/profile` - Obtener perfil (requiere token)



\### Usuarios

\- GET `/api/usuarios` - Listar usuarios (admin)

\- GET `/api/usuarios/:id` - Obtener usuario

\- PUT `/api/usuarios/:id` - Actualizar usuario

\- DELETE `/api/usuarios/:id` - Eliminar usuario (admin)



\## 🔐 Autenticación



Incluir header en peticiones protegidas:

```

Authorization: Bearer {token}

```

