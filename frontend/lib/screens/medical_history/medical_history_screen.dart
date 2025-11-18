import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/date_formatter.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia Clínica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de imprimir en desarrollo'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Imprimir Historia Clínica',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoCard(context, user),
            const SizedBox(height: 16),
            _buildTabSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BuildContext context, user) {
    // Datos de ejemplo del paciente
    final patientData = {
      'tipoSangre': 'O+',
      'eps': 'Sanitas EPS',
      'alergias': 'Penicilina, Polen',
      'edad': '34 años',
    };

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text('${patientData['edad']}'),
                      Text(user.email),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Tipo de Sangre', patientData['tipoSangre']!),
            const SizedBox(height: 8),
            _buildInfoRow('EPS', patientData['eps']!),
            const SizedBox(height: 8),
            _buildInfoRow('Alergias', patientData['alergias']!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Consultas'),
              Tab(text: 'Diagnósticos'),
              Tab(text: 'Medicamentos'),
              Tab(text: 'Exámenes'),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                _buildConsultationsTab(context),
                _buildDiagnosesTab(context),
                _buildMedicationsTab(context),
                _buildExamsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationsTab(BuildContext context) {
    final consultations = _getMockConsultations();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        final consultation = consultations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.medical_services, color: Colors.blue.shade700),
            ),
            title: Text(
              consultation['doctor'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(consultation['specialty']),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatDate(consultation['date']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Motivo de Consulta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(consultation['reason']),
                    const SizedBox(height: 16),
                    const Text(
                      'Observaciones',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(consultation['observations']),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiagnosesTab(BuildContext context) {
    final diagnoses = _getMockDiagnoses();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diagnoses.length,
      itemBuilder: (context, index) {
        final diagnosis = diagnoses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: diagnosis['severity'] == 'Alta'
                  ? Colors.red.shade100
                  : Colors.orange.shade100,
              child: Icon(
                Icons.warning,
                color: diagnosis['severity'] == 'Alta'
                    ? Colors.red.shade700
                    : Colors.orange.shade700,
              ),
            ),
            title: Text(
              diagnosis['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Doctor: ${diagnosis['doctor']}'),
                Text(DateFormatter.formatDate(diagnosis['date'])),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    'Severidad: ${diagnosis['severity']}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: diagnosis['severity'] == 'Alta'
                      ? Colors.red.shade100
                      : Colors.orange.shade100,
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildMedicationsTab(BuildContext context) {
    final medications = _getMockMedications();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        final isActive = medication['status'] == 'Activo';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade100,
              child: Icon(
                Icons.medication,
                color: isActive ? Colors.green.shade700 : Colors.grey.shade600,
              ),
            ),
            title: Text(
              medication['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medication['dosage']),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    medication['status'],
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Frecuencia', medication['frequency']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Duración', medication['duration']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Indicaciones', medication['instructions']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Prescrito por', medication['doctor']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Fecha', DateFormatter.formatDate(medication['date'])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExamsTab(BuildContext context) {
    final exams = _getMockExams();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        final hasResult = exam['hasResult'];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: hasResult ? Colors.blue.shade100 : Colors.grey.shade100,
              child: Icon(
                hasResult ? Icons.check_circle : Icons.pending,
                color: hasResult ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
            ),
            title: Text(
              exam['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Solicitado por: ${exam['doctor']}'),
                Text(DateFormatter.formatDate(exam['date'])),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    hasResult ? 'Resultados Disponibles' : 'Pendiente',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: hasResult ? Colors.blue.shade100 : Colors.grey.shade300,
                ),
              ],
            ),
            trailing: hasResult
                ? IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Descargando resultados de ${exam['name']}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  )
                : null,
            isThreeLine: true,
          ),
        );
      },
    );
  }

  // Mock data methods
  List<Map<String, dynamic>> _getMockConsultations() {
    return [
      {
        'doctor': 'Dr. Juan Pérez',
        'specialty': 'Medicina General',
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'reason': 'Control rutinario y renovación de medicamentos',
        'observations':
            'Paciente en buen estado general. Presión arterial normal. Se renueva prescripción de medicamentos habituales.',
      },
      {
        'doctor': 'Dra. María González',
        'specialty': 'Cardiología',
        'date': DateTime.now().subtract(const Duration(days: 45)),
        'reason': 'Dolor en el pecho y palpitaciones',
        'observations':
            'Electrocardiograma normal. Se solicita eco cardiograma de control. Se recomienda reducir consumo de cafeína.',
      },
      {
        'doctor': 'Dr. Carlos Ramírez',
        'specialty': 'Medicina General',
        'date': DateTime.now().subtract(const Duration(days: 90)),
        'reason': 'Gripe y malestar general',
        'observations':
            'Cuadro gripal leve. Se prescribe paracetamol y reposo. Control en 7 días si persisten síntomas.',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDiagnoses() {
    return [
      {
        'name': 'Hipertensión Arterial',
        'doctor': 'Dra. María González',
        'date': DateTime.now().subtract(const Duration(days: 180)),
        'severity': 'Media',
      },
      {
        'name': 'Gastritis Crónica',
        'doctor': 'Dr. Juan Pérez',
        'date': DateTime.now().subtract(const Duration(days: 365)),
        'severity': 'Baja',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockMedications() {
    return [
      {
        'name': 'Losartán 50mg',
        'dosage': '1 tableta',
        'frequency': 'Una vez al día',
        'duration': 'Tratamiento continuo',
        'instructions': 'Tomar en ayunas, preferiblemente en la mañana',
        'doctor': 'Dra. María González',
        'date': DateTime.now().subtract(const Duration(days: 180)),
        'status': 'Activo',
      },
      {
        'name': 'Omeprazol 20mg',
        'dosage': '1 cápsula',
        'frequency': 'Dos veces al día',
        'duration': '30 días',
        'instructions': 'Tomar 30 minutos antes de las comidas principales',
        'doctor': 'Dr. Juan Pérez',
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'status': 'Activo',
      },
      {
        'name': 'Paracetamol 500mg',
        'dosage': '1-2 tabletas',
        'frequency': 'Cada 8 horas según necesidad',
        'duration': '7 días',
        'instructions': 'Tomar después de las comidas. No exceder 6 tabletas al día',
        'doctor': 'Dr. Carlos Ramírez',
        'date': DateTime.now().subtract(const Duration(days: 90)),
        'status': 'Completado',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockExams() {
    return [
      {
        'name': 'Hemograma Completo',
        'doctor': 'Dr. Juan Pérez',
        'date': DateTime.now().subtract(const Duration(days: 20)),
        'hasResult': true,
      },
      {
        'name': 'Ecocardiograma',
        'doctor': 'Dra. María González',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'hasResult': false,
      },
      {
        'name': 'Perfil Lipídico',
        'doctor': 'Dr. Juan Pérez',
        'date': DateTime.now().subtract(const Duration(days: 60)),
        'hasResult': true,
      },
      {
        'name': 'Radiografía de Tórax',
        'doctor': 'Dr. Carlos Ramírez',
        'date': DateTime.now().subtract(const Duration(days: 95)),
        'hasResult': true,
      },
    ];
  }
}
