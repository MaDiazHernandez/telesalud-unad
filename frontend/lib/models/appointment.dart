import 'user.dart';

class Appointment {
  final int id;
  final int patientId;
  final int doctorId;
  final DateTime appointmentDate;
  final String reason;
  final String status;
  final String? notes;
  final User? patient;
  final User? doctor;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.reason,
    required this.status,
    this.notes,
    this.patient,
    this.doctor,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pendiente';
  bool get isConfirmed => status == 'confirmada';
  bool get isCompleted => status == 'completada';
  bool get isCancelled => status == 'cancelada';

  String get statusLabel {
    switch (status) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmada':
        return 'Confirmada';
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return status;
    }
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      reason: json['reason'],
      status: json['status'],
      notes: json['notes'],
      patient: json['patient'] != null ? User.fromJson(json['patient']) : null,
      doctor: json['doctor'] != null ? User.fromJson(json['doctor']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'reason': reason,
      'status': status,
      'notes': notes,
      'patient': patient?.toJson(),
      'doctor': doctor?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    int? id,
    int? patientId,
    int? doctorId,
    DateTime? appointmentDate,
    String? reason,
    String? status,
    String? notes,
    User? patient,
    User? doctor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
