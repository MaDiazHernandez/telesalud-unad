class User {
  final int id;
  final String email;
  final String nombre;
  final String apellido;
  final String documento;
  final String telefono;
  final String rol;
  final bool activo;
  final DateTime? ultimoAcceso;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  User({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.documento,
    required this.telefono,
    required this.rol,
    required this.activo,
    this.ultimoAcceso,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  String get fullName => '$nombre $apellido';

  bool get isAdmin => rol == 'administrador';
  bool get isDoctor => rol == 'profesional';
  bool get isPatient => rol == 'paciente';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['usuario_id'] ?? json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      documento: json['documento'],
      telefono: json['telefono'] ?? '',
      rol: json['rol'],
      activo: json['activo'] ?? true,
      ultimoAcceso: json['ultimo_acceso'] != null 
          ? DateTime.parse(json['ultimo_acceso']) 
          : null,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': id,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'documento': documento,
      'telefono': telefono,
      'rol': rol,
      'activo': activo,
      'ultimo_acceso': ultimoAcceso?.toIso8601String(),
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? nombre,
    String? apellido,
    String? documento,
    String? telefono,
    String? rol,
    bool? activo,
    DateTime? ultimoAcceso,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      documento: documento ?? this.documento,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      activo: activo ?? this.activo,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
