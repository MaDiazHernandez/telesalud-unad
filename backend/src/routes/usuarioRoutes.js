const express = require('express');
const router = express.Router();
const usuarioController = require('../controllers/usuarioController');
const { verifyToken, verifyRole } = require('../middlewares/auth');

// Todas las rutas requieren autenticación
router.use(verifyToken);

// Obtener todos los usuarios (solo admin)
router.get('/', verifyRole('administrador'), usuarioController.getAllUsuarios);

// Obtener usuario por ID
router.get('/:id', usuarioController.getUsuarioById);

// Actualizar usuario
router.put('/:id', usuarioController.updateUsuario);

// Eliminar usuario (solo admin)
router.delete('/:id', verifyRole('administrador'), usuarioController.deleteUsuario);

module.exports = router;