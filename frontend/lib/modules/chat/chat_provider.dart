import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  Stream getMessages(String me, String other) {
    return _chatService.getMessages(me, other);
  }

  Future<void> sendMessage(String me, String other, String text) {
    return _chatService.sendMessage(me, other, text);
  }
}
