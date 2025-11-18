import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Definición de un modelo simple para el mensaje de chat
class ChatMessage {
  final String chatId;
  final int senderId;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  final String _serverUrl = 'http://192.168.18.246:3000'; // **IMPORTANTE: Edwin debe cambiar esto**
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  SocketService() {
    _initSocket();
  }

  void _initSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Asumiendo que el token se guarda aquí

    if (token == null) {
      print('Error: Token de autenticación no encontrado.');
      return;
    }

    _socket = IO.io(_serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Content-Type': 'application/json'},
      'auth': {'token': token}, // Autenticación con JWT
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Socket conectado');
    });

    _socket.onDisconnect((_) {
      print('Socket desconectado');
    });

    _socket.onConnectError((err) {
      print('Error de conexión de Socket: $err');
    });

    // Escuchar nuevos mensajes
    _socket.on('receive_message', (data) {
      final message = ChatMessage.fromJson(data);
      _messages.add(message);
      notifyListeners();
    });
  }

  void joinChat(String chatId) {
    if (_socket.connected) {
      _socket.emit('join_chat', chatId);
    }
  }

  void sendMessage({
    required String chatId,
    required int receiverId,
    required String content,
  }) {
    if (_socket.connected) {
      _socket.emit('send_message', {
        'chatId': chatId,
        'receiverId': receiverId,
        'content': content,
      });
    }
  }

  void disposeSocket() {
    _socket.disconnect();
    _socket.dispose();
  }
}
