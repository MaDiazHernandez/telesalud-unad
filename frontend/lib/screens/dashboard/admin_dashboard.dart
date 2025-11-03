import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
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
            Text('Acciones Rápidas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildQuickActions(context),
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
                  child: Icon(Icons.admin_panel_settings, size: 32, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 10),
                Text(user.fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Administrador', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Inicio'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.people), title: const Text('Usuarios'), onTap: () {}),
          ListTile(leading: const Icon(Icons.medical_services), title: const Text('Médicos'), onTap: () {}),
          ListTile(leading: const Icon(Icons.person), title: const Text('Pacientes'), onTap: () {}),
          ListTile(leading: const Icon(Icons.bar_chart), title: const Text('Reportes'), onTap: () {}),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Configuración'), onTap: () {}),
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
                  Text('Administrador: ${user.nombre}', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Panel de Control del Sistema', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Icon(Icons.admin_panel_settings, size: 48, color: Theme.of(context).primaryColor),
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
        _buildStatCard(context, '156', 'Usuarios', Icons.people, Colors.blue),
        _buildStatCard(context, '24', 'Médicos', Icons.medical_services, Colors.green),
        _buildStatCard(context, '132', 'Pacientes', Icons.person, Colors.orange),
        _buildStatCard(context, '89', 'Citas Hoy', Icons.event, Colors.purple),
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

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_add)),
          title: const Text('Crear Usuario'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.bar_chart)),
          title: const Text('Ver Reportes'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.settings)),
          title: const Text('Configuración del Sistema'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ],
    );
  }
}