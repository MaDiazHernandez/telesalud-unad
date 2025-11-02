module.exports = (sequelize, DataTypes) => {
  const Profesional = sequelize.define('Profesional', {
    profesional_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    usuario_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      unique: true,
      references: {
        model: 'usuarios',
        key: 'usuario_id',
      },
    },
    especialidad: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    registro_medico: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: true,
    },
    biografia: {
      type: DataTypes.TEXT,
    },
  }, {
    tableName: 'profesionales',
    timestamps: true,
    createdAt: 'fecha_creacion',
    updatedAt: 'fecha_actualizacion',
  });

  return Profesional;
};