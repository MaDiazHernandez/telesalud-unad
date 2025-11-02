const express = require('express');
const router = express.Router();

const authRoutes = require('./authRoutes');
const usuarioRoutes = require('./usuarioRoutes');

// Definir rutas
router.use('/auth', authRoutes);
router.use('/usuarios', usuarioRoutes);

// Ruta de prueba
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'API Telesalud funcionando correctamente',
    timestamp: new Date().toISOString(),
  });
});

module.exports = router;