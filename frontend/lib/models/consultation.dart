import 'user.dart';
import 'appointment.dart';

class Consultation {
  final int id;
  final int appointmentId;
  final int patientId;
  final int doctorId;
  final String diagnosis;
  final String treatment;
  final String? observations;
  final String? symptoms;
  final String? vitalSigns;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final Appointment? appointment;
  final User? patient;
  final User? doctor;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consultation({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.treatment,
    this.observations,
    this.symptoms,
    this.vitalSigns,
    required this.status,
    this.startTime,
    this.endTime,
    this.appointment,
    this.patient,
    this.doctor,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isScheduled => status == 'programada';
  bool get isInProgress => status == 'en_progreso';
  bool get isCompleted => status == 'completada';
  bool get isCancelled => status == 'cancelada';

  String get statusLabel {
    switch (status) {
      case 'programada':
        return 'Programada';
      case 'en_progreso':
        return 'En Progreso';
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return status;
    }
  }

  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'],
      appointmentId: json['appointmentId'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      observations: json['observations'],
      symptoms: json['symptoms'],
      vitalSigns: json['vitalSigns'],
      status: json['status'],
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime']) 
          : null,
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime']) 
          : null,
      appointment: json['appointment'] != null 
          ? Appointment.fromJson(json['appointment']) 
          : null,
      patient: json['patient'] != null 
          ? User.fromJson(json['patient']) 
          : null,
      doctor: json['doctor'] != null 
          ? User.fromJson(json['doctor']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'observations': observations,
      'symptoms': symptoms,
      'vitalSigns': vitalSigns,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'appointment': appointment?.toJson(),
      'patient': patient?.toJson(),
      'doctor': doctor?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
