import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Enviar un mensaje
  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    final chatId = getChatId(senderId, receiverId);

    await _db.collection("chats").doc(chatId).collection("messages").add({
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  // Escuchar mensajes en tiempo real
  Stream<QuerySnapshot> getMessages(String user1, String user2) {
    final chatId = getChatId(user1, user2);

    return _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Generar ID único para cada chat
  String getChatId(String a, String b) {
    return (a.compareTo(b) < 0) ? "$a-$b" : "$b-$a";
  }
}
