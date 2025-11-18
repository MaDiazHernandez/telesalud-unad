import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String? text;
  final String? imageUrl;
  final Timestamp? timestamp;

  const ChatBubble({
    super.key,
    required this.isMe,
    this.text,
    this.imageUrl,
    this.timestamp,
  });

  String _formatTime(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    return DateFormat.Hm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blueAccent : Colors.grey.shade200;
    final txtColor = isMe ? Colors.white : Colors.black87;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft:
          isMe ? const Radius.circular(12) : const Radius.circular(3),
      bottomRight:
          isMe ? const Radius.circular(3) : const Radius.circular(12),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: imageUrl != null ? EdgeInsets.zero : const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl!, fit: BoxFit.cover),
              ),
            if (text != null && text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(text!, style: TextStyle(color: txtColor)),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
              child: Text(_formatTime(timestamp),
                  style: TextStyle(color: txtColor.withOpacity(0.7), fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

