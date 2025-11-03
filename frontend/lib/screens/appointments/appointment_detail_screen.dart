import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../core/utils/date_formatter.dart';
import '../../config/theme.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get appointment from arguments or API
    // final appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
    
    // Mock data for now
    final appointment = Appointment(
      id: 1,
      patientId: 1,
      doctorId: 2,
      appointmentDate: DateTime.now().add(const Duration(days: 2)),
      reason: 'Consulta general',
      status: 'confirmada',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final statusColor = AppTheme.getStatusColor(appointment.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cita'),
        actions: [
          if (appointment.isPending || appointment.isConfirmed)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Navigate to edit appointment
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              color: statusColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getStatusIcon(appointment.status),
                    color: statusColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    appointment.statusLabel,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Information
                  _buildSection(
                    context,
                    title: 'Médico',
                    child: Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(appointment.doctor?.fullName ?? 'Dr. Juan Pérez'),
                        subtitle: const Text('Medicina General'),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            // TODO: Call doctor
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Date and Time
                  _buildSection(
                    context,
                    title: 'Fecha y Hora',
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              icon: Icons.calendar_today,
                              label: 'Fecha',
                              value: DateFormatter.formatDateLong(appointment.appointmentDate),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              icon: Icons.access_time,
                              label: 'Hora',
                              value: DateFormatter.formatTime(appointment.appointmentDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Reason
                  _buildSection(
                    context,
                    title: 'Motivo de la Consulta',
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          appointment.reason,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  
                  // Notes (if any)
                  if (appointment.notes != null) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      title: 'Notas Adicionales',
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            appointment.notes!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Patient Information (for doctors/admins)
                  _buildSection(
                    context,
                    title: 'Información del Paciente',
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              icon: Icons.person,
                              label: 'Nombre',
                              value: appointment.patient?.fullName ?? 'Paciente',
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              icon: Icons.phone,
                              label: 'Teléfono',
                              value: appointment.patient?.telefono ?? 'No disponible',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  if (appointment.isConfirmed) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/video-call', arguments: appointment.id);
                      },
                      icon: const Icon(Icons.video_call),
                      label: const Text('Unirse a Videollamada'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (appointment.isPending || appointment.isConfirmed) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context, appointment);
                      },
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      label: const Text('Cancelar Cita', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pendiente':
        return Icons.pending;
      case 'confirmada':
        return Icons.check_circle;
      case 'completada':
        return Icons.done_all;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _showCancelDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Cita'),
        content: const Text('¿Estás seguro de que deseas cancelar esta cita? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Cancel appointment via API
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cita cancelada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Sí, Cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}