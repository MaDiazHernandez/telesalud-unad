const jwt = require('jsonwebtoken');
const config = require('../config');

// Middleware para verificar JWT
exports.verifyToken = (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token no proporcionado',
      });
    }

    const decoded = jwt.verify(token, config.jwt.secret);
    req.userId = decoded.userId;
    req.userRol = decoded.rol;

    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: 'Token inválido o expirado',
    });
  }
};

// Middleware para verificar roles
exports.verifyRole = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.userRol)) {
      return res.status(403).json({
        success: false,
        message: 'No tienes permisos para acceder a este recurso',
      });
    }
    next();
  };
};