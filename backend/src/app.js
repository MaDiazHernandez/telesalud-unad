const express = require('express');
const cors = require('cors');
const config = require('./config');
const db = require('./models');
const routes = require("./routes");
const http = require("http");
const initChatServer = require("./chat");

const app = express();
const server = http.createServer(app);

// Middlewares
app.use(cors(config.cors));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rutas
app.use("/api", routes);

// Inicializar el servidor de chat
initChatServer(server);

// Ruta raíz
app.get('/', (req, res) => {
  res.json({
    message: 'API Telesalud - Sistema de Atención Médica a Distancia',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: '/api/auth',
      usuarios: '/api/usuarios',
    },
  });
});

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Ruta no encontrada',
  });
});

// Conectar a la base de datos e iniciar servidor
const PORT = config.port;

db.sequelize
  .authenticate()
  .then(() => {
    console.log('✅ Conexión a PostgreSQL establecida');
    
    // Sincronizar modelos (crear tablas si no existen)
    return db.sequelize.sync();
  })
  .then(() => {
    console.log('✅ Modelos sincronizados');
    
    server.listen(PORT, () => {
      console.log('\n' + '='.repeat(50));
      console.log('🚀 Servidor corriendo en:');
      console.log(`   http://localhost:${PORT}`);
      console.log('='.repeat(50) + '\n');
    });
  })
  .catch((error) => {
    console.error('❌ Error al conectar con la base de datos:', error);
    process.exit(1);
  });

module.exports = { app, server };