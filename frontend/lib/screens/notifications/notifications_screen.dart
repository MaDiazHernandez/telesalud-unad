import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/date_formatter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userRole = auth.user!.rol;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las notificaciones marcadas como leídas'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Marcar todas como leídas',
          ),
        ],
      ),
      body: _buildNotificationsList(context, userRole),
    );
  }

  Widget _buildNotificationsList(BuildContext context, String userRole) {
    final notifications = _getNotificationsByRole(userRole);

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No tienes notificaciones',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(context, notification);
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notification) {
    final isRead = notification['read'] ?? false;
    final type = notification['type'] ?? 'info';
    
    IconData icon;
    Color color;
    
    switch (type) {
      case 'appointment':
        icon = Icons.calendar_today;
        color = Colors.blue;
        break;
      case 'message':
        icon = Icons.message;
        color = Colors.green;
        break;
      case 'reminder':
        icon = Icons.alarm;
        color = Colors.orange;
        break;
      case 'alert':
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: isRead ? 0 : 2,
      color: isRead ? Colors.grey.shade50 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification['message']),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatRelativeTime(notification['date']),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          _showNotificationDetail(context, notification);
        },
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message']),
            const SizedBox(height: 16),
            Text(
              DateFormatter.formatDateTime(notification['date']),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getNotificationsByRole(String userRole) {
    final now = DateTime.now();
    
    if (userRole == 'paciente') {
      return [
        {
          'title': 'Recordatorio de Cita',
          'message': 'Tienes una cita mañana con Dr. Juan Pérez a las 10:00 AM',
          'type': 'appointment',
          'date': now.subtract(const Duration(hours: 2)),
          'read': false,
        },
        {
          'title': 'Resultado de Exámenes',
          'message': 'Los resultados de tus exámenes ya están disponibles',
          'type': 'alert',
          'date': now.subtract(const Duration(hours: 5)),
          'read': false,
        },
        {
          'title': 'Toma de Medicamento',
          'message': 'Recuerda tomar tu medicamento de las 8:00 PM',
          'type': 'reminder',
          'date': now.subtract(const Duration(hours: 10)),
          'read': true,
        },
        {
          'title': 'Mensaje de tu Médico',
          'message': 'Dra. María González te ha enviado un mensaje',
          'type': 'message',
          'date': now.subtract(const Duration(days: 1)),
          'read': true,
        },
        {
          'title': 'Cita Confirmada',
          'message': 'Tu cita del 20 de noviembre ha sido confirmada',
          'type': 'appointment',
          'date': now.subtract(const Duration(days: 2)),
          'read': true,
        },
      ];
    } else if (userRole == 'profesional') {
      return [
        {
          'title': 'Nueva Cita Agendada',
          'message': 'Ana García ha agendado una cita para mañana a las 9:00 AM',
          'type': 'appointment',
          'date': now.subtract(const Duration(minutes: 30)),
          'read': false,
        },
        {
          'title': 'Solicitud de Consulta Urgente',
          'message': 'Pedro Martínez solicita una consulta urgente',
          'type': 'alert',
          'date': now.subtract(const Duration(hours: 1)),
          'read': false,
        },
        {
          'title': 'Mensaje de Paciente',
          'message': 'Laura López te ha enviado un mensaje en el chat',
          'type': 'message',
          'date': now.subtract(const Duration(hours: 3)),
          'read': false,
        },
        {
          'title': 'Recordatorio de Cita',
          'message': 'Tienes 3 citas programadas para hoy',
          'type': 'reminder',
          'date': now.subtract(const Duration(hours: 8)),
          'read': true,
        },
        {
          'title': 'Actualización del Sistema',
          'message': 'Nueva funcionalidad de historia clínica disponible',
          'type': 'info',
          'date': now.subtract(const Duration(days: 1)),
          'read': true,
        },
      ];
    } else {
      // Administrador
      return [
        {
          'title': 'Nuevo Usuario Registrado',
          'message': '5 nuevos pacientes se han registrado hoy',
          'type': 'info',
          'date': now.subtract(const Duration(minutes: 15)),
          'read': false,
        },
        {
          'title': 'Reporte Mensual Disponible',
          'message': 'El reporte de actividades de octubre está listo',
          'type': 'alert',
          'date': now.subtract(const Duration(hours: 2)),
          'read': false,
        },
        {
          'title': 'Mantenimiento Programado',
          'message': 'El sistema tendrá mantenimiento el domingo a las 2:00 AM',
          'type': 'reminder',
          'date': now.subtract(const Duration(hours: 6)),
          'read': true,
        },
        {
          'title': 'Solicitud de Soporte',
          'message': 'Dr. Juan Pérez ha solicitado soporte técnico',
          'type': 'message',
          'date': now.subtract(const Duration(days: 1)),
          'read': true,
        },
      ];
    }
  }
}
