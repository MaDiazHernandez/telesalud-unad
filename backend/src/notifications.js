const admin = require('firebase-admin');
const config = require('./config');

// Asegúrate de que el archivo de credenciales de Firebase esté en tu proyecto
// y que la variable de entorno FIREBASE_CREDENTIALS_PATH esté configurada.
// Por ahora, asumiremos que el archivo de credenciales está en la raíz del backend.
const serviceAccount = require('../../firebase-adminsdk.json'); // Edwin debe crear este archivo

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

/**
 * Envía una notificación push a un dispositivo específico.
 * @param {string} deviceToken - El token de registro del dispositivo (FCM Token).
 * @param {object} notification - Objeto con los campos 'title' y 'body' para la notificación.
 * @param {object} data - Objeto con datos personalizados a enviar (payload).
 */
const sendPushNotification = async (deviceToken, notification, data = {}) => {
  const message = {
    notification: notification,
    data: data,
    token: deviceToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Notificación enviada con éxito:', response);
    return response;
  } catch (error) {
    console.error('Error al enviar la notificación:', error);
    throw error;
  }
};

module.exports = {
  sendPushNotification,
};
