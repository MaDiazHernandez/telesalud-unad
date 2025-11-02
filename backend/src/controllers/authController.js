const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../models');
const config = require('../config');

// Función para generar JWT
const generateToken = (userId, rol) => {
  return jwt.sign(
    { userId, rol },
    config.jwt.secret,
    { expiresIn: config.jwt.expire }
  );
};

// Registro de usuario
exports.register = async (req, res) => {
  try {
    const { nombre, apellido, documento, email, telefono, password, rol } = req.body;

    // Verificar si el usuario ya existe
    const existeUsuario = await db.Usuario.findOne({
      where: { email },
    });

    if (existeUsuario) {
      return res.status(400).json({
        success: false,
        message: 'El email ya está registrado',
      });
    }

    // Verificar documento
    const existeDocumento = await db.Usuario.findOne({
      where: { documento },
    });

    if (existeDocumento) {
      return res.status(400).json({
        success: false,
        message: 'El documento ya está registrado',
      });
    }

    // Hashear password
    const passwordHash = await bcrypt.hash(password, 10);

    // Crear usuario
    const usuario = await db.Usuario.create({
      nombre,
      apellido,
      documento,
      email,
      telefono,
      password_hash: passwordHash,
      rol: rol || 'paciente',
      activo: true,
    });

    // Generar token
    const token = generateToken(usuario.usuario_id, usuario.rol);

    res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente',
      data: {
        usuario: {
          id: usuario.usuario_id,
          nombre: usuario.nombre,
          apellido: usuario.apellido,
          email: usuario.email,
          rol: usuario.rol,
        },
        token,
      },
    });
  } catch (error) {
    console.error('Error en registro:', error);
    res.status(500).json({
      success: false,
      message: 'Error al registrar usuario',
      error: error.message,
    });
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Buscar usuario
    const usuario = await db.Usuario.findOne({
      where: { email },
      include: [
        {
          model: db.Paciente,
          as: 'paciente',
        },
        {
          model: db.Profesional,
          as: 'profesional',
        },
      ],
    });

    if (!usuario) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales incorrectas',
      });
    }

    // Verificar si está activo
    if (!usuario.activo) {
      return res.status(403).json({
        success: false,
        message: 'Usuario inactivo',
      });
    }

    // Verificar password
    const passwordValido = await bcrypt.compare(password, usuario.password_hash);

    if (!passwordValido) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales incorrectas',
      });
    }

    // Actualizar último acceso
    await usuario.update({ ultimo_acceso: new Date() });

    // Generar token
    const token = generateToken(usuario.usuario_id, usuario.rol);

    res.json({
      success: true,
      message: 'Login exitoso',
      data: {
        usuario: {
          id: usuario.usuario_id,
          nombre: usuario.nombre,
          apellido: usuario.apellido,
          email: usuario.email,
          documento: usuario.documento,
          telefono: usuario.telefono,
          rol: usuario.rol,
          paciente: usuario.paciente,
          profesional: usuario.profesional,
        },
        token,
      },
    });
  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({
      success: false,
      message: 'Error al iniciar sesión',
      error: error.message,
    });
  }
};

// Obtener perfil del usuario autenticado
exports.getProfile = async (req, res) => {
  try {
    const usuario = await db.Usuario.findByPk(req.userId, {
      attributes: { exclude: ['password_hash'] },
      include: [
        {
          model: db.Paciente,
          as: 'paciente',
        },
        {
          model: db.Profesional,
          as: 'profesional',
        },
      ],
    });

    if (!usuario) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado',
      });
    }

    res.json({
      success: true,
      data: usuario,
    });
  } catch (error) {
    console.error('Error al obtener perfil:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener perfil',
      error: error.message,
    });
  }
};