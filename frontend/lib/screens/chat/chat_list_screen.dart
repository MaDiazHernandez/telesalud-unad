import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    context.read<ChatProvider>().listenChats(user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final userId = auth.user!.id.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder(
        stream: chatProvider.chatsStream,
        builder: (context, snapshot) {
          // Mientras carga o si no hay datos de Firebase, mostrar lista de ejemplo
          if (!snapshot.hasData || snapshot.hasError) {
            return _buildDemoList(context, auth);
          }
          
          final docs = (snapshot.data as dynamic).docs;
          if (docs.isEmpty) {
            return _buildDemoList(context, auth);
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final chat = docs[i];
              final participants = List<String>.from(chat['participants'] ?? []);
              final other = participants.firstWhere((p) => p != userId, orElse: () => 'Soporte');
              final last = chat['lastMessage'] ?? '';
              final updated = chat['updatedAt'];

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(other),
                subtitle: Text(last),
                trailing: updated != null ? Text(
                  // format time
                  DateTime.fromMillisecondsSinceEpoch((updated as dynamic).millisecondsSinceEpoch).hour.toString()
                ) : null,
                onTap: () async {
                  await chatProvider.openChat(userId, other);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(chatId: chatProvider.currentChatId!, otherId: other),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Lista de ejemplo para cuando Firebase no está configurado
  Widget _buildDemoList(BuildContext context, AuthProvider auth) {
    final userRole = auth.user!.rol;
    
    // Contactos según el rol del usuario
    List<Map<String, String>> demoContacts = [];
    
    if (userRole == 'paciente') {
      demoContacts = [
        {'name': 'Dr. Juan Pérez', 'role': 'Medicina General', 'lastMessage': 'Buenos días, ¿cómo se encuentra?'},
        {'name': 'Dra. María González', 'role': 'Cardiología', 'lastMessage': 'Recuerde tomar su medicamento'},
        {'name': 'Soporte Técnico', 'role': 'Asistencia', 'lastMessage': '¿En qué podemos ayudarle?'},
      ];
    } else if (userRole == 'profesional') {
      demoContacts = [
        {'name': 'Ana García', 'role': 'Paciente', 'lastMessage': 'Gracias doctor'},
        {'name': 'Pedro Martínez', 'role': 'Paciente', 'lastMessage': 'Tengo una consulta'},
        {'name': 'Laura López', 'role': 'Paciente', 'lastMessage': 'Buenos días'},
      ];
    } else {
      demoContacts = [
        {'name': 'Dr. Juan Pérez', 'role': 'Médico', 'lastMessage': 'Reporte enviado'},
        {'name': 'Dra. María González', 'role': 'Médico', 'lastMessage': 'Confirmado'},
        {'name': 'Soporte Técnico', 'role': 'Asistencia', 'lastMessage': 'Sistema actualizado'},
      ];
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chat en modo demo. Firebase no configurado.',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: demoContacts.length,
            itemBuilder: (context, index) {
              final contact = demoContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    contact['name']![0],
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(contact['name']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['role']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact['lastMessage']!,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat en modo demo. Configure Firebase para chat real.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
