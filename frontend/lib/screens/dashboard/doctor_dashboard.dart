import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chat-list');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, user, authProvider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context, user),
            const SizedBox(height: 24),
            _buildStatsGrid(context),
            const SizedBox(height: 24),
            Text('Citas de Hoy', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildAppointmentsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, user, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.medical_services, size: 32, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 10),
                Text(user.fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Médico', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Inicio'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Agenda'), onTap: () => Navigator.pushNamed(context, '/appointments')),
          ListTile(leading: const Icon(Icons.people), title: const Text('Pacientes'), onTap: () {}),
          ListTile(leading: const Icon(Icons.person), title: const Text('Perfil'), onTap: () => Navigator.pushNamed(context, '/profile')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. ${user.nombre}', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Panel de Control Médico', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Icon(Icons.medical_services, size: 48, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(context, '8', 'Citas Hoy', Icons.event, Colors.blue),
        _buildStatCard(context, '45', 'Pacientes', Icons.people, Colors.green),
        _buildStatCard(context, '3', 'Pendientes', Icons.pending, Colors.orange),
        _buildStatCard(context, '127', 'Completadas', Icons.check_circle, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(child: Text('P${index + 1}')),
            title: Text('Paciente ${index + 1}'),
            subtitle: Text('${10 + index}:00 AM - Consulta General'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Iniciar'),
            ),
          ),
        );
      }),
    );
  }
}