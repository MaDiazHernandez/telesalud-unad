import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/date_formatter.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telesalud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.nombre[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Mis Citas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Historia Clínica'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to medical history
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${user.nombre}!',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bienvenido a tu portal de salud',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.waving_hand,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.add_circle,
                  title: 'Nueva Cita',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/create-appointment');
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Mis Citas',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/appointments');
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.medical_services,
                  title: 'Historia Clínica',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Navigate to medical history
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.video_call,
                  title: 'Consulta Virtual',
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Navigate to video call
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Upcoming Appointments
            Text(
              'Próximas Citas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            // TODO: Replace with real data from API
            _buildAppointmentCard(
              context,
              doctorName: 'Dr. Juan Pérez',
              specialty: 'Medicina General',
              date: DateTime.now().add(const Duration(days: 2)),
              status: 'confirmada',
            ),
            const SizedBox(height: 12),
            _buildAppointmentCard(
              context,
              doctorName: 'Dra. María González',
              specialty: 'Cardiología',
              date: DateTime.now().add(const Duration(days: 5)),
              status: 'pendiente',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-appointment');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context, {
    required String doctorName,
    required String specialty,
    required DateTime date,
    required String status,
  }) {
    Color statusColor;
    String statusText;
    
    switch (status) {
      case 'pendiente':
        statusColor = Colors.orange;
        statusText = 'Pendiente';
        break;
      case 'confirmada':
        statusColor = Colors.blue;
        statusText = 'Confirmada';
        break;
      case 'completada':
        statusColor = Colors.green;
        statusText = 'Completada';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Cancelada';
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.medical_services, color: statusColor),
        ),
        title: Text(doctorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(specialty),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatAppointmentDate(date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          backgroundColor: statusColor,
        ),
        onTap: () {
          // TODO: Navigate to appointment detail
        },
      ),
    );
  }
}