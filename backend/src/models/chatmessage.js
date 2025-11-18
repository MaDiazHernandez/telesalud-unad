'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ChatMessage extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      ChatMessage.belongsTo(models.Usuario, { foreignKey: 'senderId', as: 'sender' });
      ChatMessage.belongsTo(models.Usuario, { foreignKey: 'receiverId', as: 'receiver' });
      // Asumiendo que tienes un modelo de Conversación (Chat)
      // ChatMessage.belongsTo(models.Chat, { foreignKey: 'chatId', as: 'chat' });
    }
  }
  ChatMessage.init({
    chatId: {
      type: DataTypes.STRING, // ID de la conversación (puede ser una combinación de IDs de usuario)
      allowNull: false,
    },
    senderId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'usuarios', // Nombre de la tabla de usuarios
        key: 'usuario_id',
      }
    },
    receiverId: {
      type: DataTypes.INTEGER,
      allowNull: true, // Puede ser nulo si es un chat grupal o si se usa chatId
      references: {
        model: 'usuarios', // Nombre de la tabla de usuarios
        key: 'usuario_id',
      }
    },
    content: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    read: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
  }, {
    sequelize,
    modelName: 'ChatMessage',
    tableName: 'ChatMessages',
  });
  return ChatMessage;
};
