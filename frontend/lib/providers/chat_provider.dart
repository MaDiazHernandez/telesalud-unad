import 'dart:io';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  String? currentChatId;
  String? currentOtherUserId;
  bool isTyping = false;

  // Streams
  Stream? messagesStream;
  Stream? chatsStream;

  // Inicializar streams de chats para el usuario
  void listenChats(String userId) {
    chatsStream = _service.getChats(userId);
    notifyListeners();
  }

  // Abrir/crear chat entre dos usuarios
  Future<void> openChat(String meId, String otherId) async {
    currentChatId = await _service.createOrGetChat(meId, otherId);
    currentOtherUserId = otherId;
    messagesStream = _service.getMessages(currentChatId!);
    notifyListeners();
  }

  // Enviar texto
  Future<void> sendText(String senderId, String text) async {
    if (currentChatId == null) return;
    await _service.sendMessage(
        chatId: currentChatId!, senderId: senderId, text: text);
  }

  // Enviar imagen
  Future<void> sendImage(String senderId, File file) async {
    if (currentChatId == null) return;
    final url = await _service.uploadImage(file);
    await _service.sendMessage(
        chatId: currentChatId!, senderId: senderId, imageUrl: url);
  }

  // Typing
  void setTyping(String userId, bool typing) {
    if (currentChatId == null) return;
    _service.setTyping(currentChatId!, userId, typing);
  }

  // Obtener typing map snapshot stream (desde document)
  Stream<DocumentSnapshot>? typingStream() {
    if (currentChatId == null) return null;
    return _service.getTypingStream(currentChatId!);
  }
}
