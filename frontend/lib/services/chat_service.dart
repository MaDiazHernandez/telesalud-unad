import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Obtener lista de chats donde participe userId
  Stream<QuerySnapshot> getChats(String userId) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // Obtener mensajes de un chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Buscar o crear un chat entre dos usuarios
  Future<String> createOrGetChat(String userA, String userB) async {
    final q = await _db
        .collection('chats')
        .where('participants', arrayContains: userA)
        .get();

    for (final doc in q.docs) {
      final participants = List<String>.from(doc['participants'] ?? []);
      if (participants.contains(userB) && participants.length == 2) {
        return doc.id;
      }
    }

    final newDoc = await _db.collection('chats').add({
      'participants': [userA, userB],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
      'typing': {}, // mapa para estados typing
    });

    return newDoc.id;
  }

  // Enviar mensaje (texto o imagen)
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    String? text,
    String? imageUrl,
  }) async {
    final msgRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'id': msgRef.id,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('chats').doc(chatId).update({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': text ?? (imageUrl != null ? '[Imagen]' : null),
    });
  }

  // Subir imagen a Firebase Storage y devolver URL
  Future<String> uploadImage(File file) async {
    final ref = _storage
        .ref()
        .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  // Set typing status
  Future<void> setTyping(String chatId, String userId, bool isTyping) async {
    final docRef = _db.collection('chats').doc(chatId);
    return docRef.set({
      'typing': {userId: isTyping}
    }, SetOptions(merge: true));
  }

  // Obtener stream de typing
  Stream<DocumentSnapshot> getTypingStream(String chatId) {
    return _db.collection('chats').doc(chatId).snapshots();
  }
}
