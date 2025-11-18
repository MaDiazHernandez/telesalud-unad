const { Sequelize } = require('sequelize');
const config = require('../config/database');

const env = process.env.NODE_ENV || 'development';
const dbConfig = config[env];

const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  {
    host: dbConfig.host,
    port: dbConfig.port,
    dialect: dbConfig.dialect,
    logging: dbConfig.logging,
    define: dbConfig.define,
  }
);

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

// Importar modelos
db.Usuario = require('./Usuario')(sequelize, Sequelize);
db.Paciente = require('./Paciente')(sequelize, Sequelize);
db.Profesional = require('./Profesional')(sequelize, Sequelize);
db.ChatMessage = require('./chatmessage')(sequelize, Sequelize);

// Definir relaciones
db.Usuario.hasOne(db.Paciente, {
  foreignKey: 'usuario_id',
  as: 'paciente',
});
db.Paciente.belongsTo(db.Usuario, {
  foreignKey: 'usuario_id',
  as: 'usuario',
});

db.Usuario.hasOne(db.Profesional, {
  foreignKey: 'usuario_id',
  as: 'profesional',
});
db.Profesional.belongsTo(db.Usuario, {
  foreignKey: 'usuario_id',
  as: 'usuario',
});

// Definir asociaciones
Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

module.exports = db;