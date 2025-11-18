const { Server } = require("socket.io");
const jwt = require('jsonwebtoken');
const config = require('./config');
const db = require('./models');
const ChatMessage = db.ChatMessage; // Asumiendo que crearás este modelo

// Función para inicializar el servidor de Socket.IO
const initChatServer = (server) => {
    const io = new Server(server, {
        cors: {
            origin: "*", // Permitir todas las conexiones por ahora
            methods: ["GET", "POST"]
        }
    });

    // Middleware de autenticación para Socket.IO
    io.use(async (socket, next) => {
        const token = socket.handshake.auth.token;
        if (!token) {
            return next(new Error("Authentication error: Token missing"));
        }
        try {
            const decoded = jwt.verify(token, config.jwtSecret);
            socket.userId = decoded.id;
            socket.userRole = decoded.role;
            next();
        } catch (error) {
            next(new Error("Authentication error: Invalid token"));
        }
    });

    io.on('connection', (socket) => {
        console.log(`Usuario conectado: ${socket.userId} (${socket.userRole})`);

        // Unir al usuario a una sala basada en su ID para notificaciones personales
        socket.join(socket.userId.toString());

        // Evento para unirse a una sala de chat (conversación)
        socket.on('join_chat', (chatId) => {
            socket.join(chatId);
            console.log(`Usuario ${socket.userId} se unió a la sala: ${chatId}`);
        });

        // Evento para enviar un mensaje
        socket.on('send_message', async (data) => {
            const { chatId, receiverId, content } = data;
            
            // 1. Guardar el mensaje en la base de datos (requiere el modelo ChatMessage)
            // try {
            //     const message = await ChatMessage.create({
            //         chatId: chatId,
            //         senderId: socket.userId,
            //         receiverId: receiverId,
            //         content: content,
            //     });
            // } catch (error) {
            //     console.error("Error al guardar el mensaje:", error);
            // }

            // 2. Emitir el mensaje a la sala de chat
            const messagePayload = {
                chatId,
                senderId: socket.userId,
                content,
                timestamp: new Date().toISOString(),
            };

            // Emitir a todos en la sala (incluido el remitente)
            io.to(chatId).emit('receive_message', messagePayload);

            // 3. Opcional: Enviar una notificación push al receptor si no está en línea o en la sala
            // Esto se manejaría en una función separada de notificaciones push
        });

        socket.on('disconnect', () => {
            console.log(`Usuario desconectado: ${socket.userId}`);
        });
    });

    return io;
};

module.exports = initChatServer;
