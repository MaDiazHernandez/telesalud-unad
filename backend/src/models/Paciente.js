module.exports = (sequelize, DataTypes) => {
  const Paciente = sequelize.define('Paciente', {
    paciente_id: {
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
    fecha_nacimiento: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    genero: {
      type: DataTypes.ENUM('masculino', 'femenino', 'otro'),
    },
    direccion: {
      type: DataTypes.TEXT,
    },
    ciudad: {
      type: DataTypes.STRING(100),
    },
    tipo_sangre: {
      type: DataTypes.STRING(5),
    },
    eps: {
      type: DataTypes.STRING(150),
    },
  }, {
    tableName: 'pacientes',
    timestamps: true,
    createdAt: 'fecha_creacion',
    updatedAt: 'fecha_actualizacion',
  });

  return Paciente;
};
