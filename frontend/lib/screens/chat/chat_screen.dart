import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherId;

  const ChatScreen({super.key, required this.chatId, required this.otherId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool otherTyping = false;

  @override
  void initState() {
    super.initState();
    final chatProv = context.read<ChatProvider>();
    chatProv.currentChatId = widget.chatId;
    // Listen typing
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).snapshots().listen((snap) {
      if (!snap.exists) return;
      final typing = snap.data()?['typing'] as Map<String, dynamic>? ?? {};
      final user = context.read<AuthProvider>().user!;
      setState(() {
        otherTyping = (typing[widget.otherId] ?? false) == true;
      });
    });
  }

  void _sendText(String userId) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await context.read<ChatProvider>().sendText(userId, text);
    _controller.clear();
    _scroll.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    context.read<ChatProvider>().setTyping(userId, false);
  }

  Future<void> _sendImage(String userId) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    final file = File(picked.path);
    await context.read<ChatProvider>().sendImage(userId, file);
    _scroll.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final meId = auth.user!.id.toString();
    final chatServiceStream = context.read<ChatProvider>().messagesStream;

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherId)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatServiceStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = (snapshot.data as dynamic).docs;
                return ListView.builder(
                  reverse: true,
                  controller: _scroll,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final m = docs[i];
                    final bool isMe = m['senderId'] == meId;
                    return ChatBubble(
                      isMe: isMe,
                      text: m['text'],
                      imageUrl: m['imageUrl'],
                      timestamp: m['createdAt'] as Timestamp?,
                    );
                  },
                );
              },
            ),
          ),

          // Typing indicator
          if (otherTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              alignment: Alignment.centerLeft,
              child: const Text('Escribiendo...', style: TextStyle(fontStyle: FontStyle.italic)),
            ),

          // Input area
          SafeArea(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.photo), onPressed: () => _sendImage(meId)),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (v) {
                      context.read<ChatProvider>().setTyping(meId, v.trim().isNotEmpty);
                    },
                    decoration: const InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () => _sendText(meId)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
