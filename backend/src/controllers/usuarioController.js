const db = require('../models');

// Obtener todos los usuarios
exports.getAllUsuarios = async (req, res) => {
  try {
    const usuarios = await db.Usuario.findAll({
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
      order: [['fecha_creacion', 'DESC']],
    });

    res.json({
      success: true,
      data: usuarios,
      count: usuarios.length,
    });
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener usuarios',
      error: error.message,
    });
  }
};

// Obtener usuario por ID
exports.getUsuarioById = async (req, res) => {
  try {
    const { id } = req.params;

    const usuario = await db.Usuario.findByPk(id, {
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
    console.error('Error al obtener usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener usuario',
      error: error.message,
    });
  }
};

// Actualizar usuario
exports.updateUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, apellido, telefono, activo } = req.body;

    const usuario = await db.Usuario.findByPk(id);

    if (!usuario) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado',
      });
    }

    await usuario.update({
      nombre: nombre || usuario.nombre,
      apellido: apellido || usuario.apellido,
      telefono: telefono || usuario.telefono,
      activo: activo !== undefined ? activo : usuario.activo,
    });

    res.json({
      success: true,
      message: 'Usuario actualizado exitosamente',
      data: usuario,
    });
  } catch (error) {
    console.error('Error al actualizar usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error al actualizar usuario',
      error: error.message,
    });
  }
};

// Eliminar usuario (soft delete)
exports.deleteUsuario = async (req, res) => {
  try {
    const { id } = req.params;

    const usuario = await db.Usuario.findByPk(id);

    if (!usuario) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado',
      });
    }

    await usuario.update({ activo: false });

    res.json({
      success: true,
      message: 'Usuario desactivado exitosamente',
    });
  } catch (error) {
    console.error('Error al eliminar usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error al eliminar usuario',
      error: error.message,
    });
  }
};