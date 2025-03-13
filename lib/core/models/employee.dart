class Employee {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String telefono;
  final String telefonoEmergencia;
  final String email;
  final String sexo;
  final String rol;
  final DateTime fechaContratacion;
  final bool? activo;
  final int? idHorario;

  Employee({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.dni,
    required this.telefonoEmergencia,
    required this.email,
    required this.sexo,
    required this.rol,
    required this.fechaContratacion,
    this.activo,
    this.idHorario,
  });

  // For display purposes
  String get name => '$nombre $apellido';

  // Create from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id_empleado']?.toString() ?? '', // Asegurar que sea string y nunca nulo
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      dni: json['DNI'] ?? '',
      telefono: json['telefono'] ?? '',
      telefonoEmergencia: json['telefono_emergencia'] ?? '',
      email: json['email'] ?? '',
      sexo: json['sexo'] ?? '',
      rol: json['rol'] ?? 'empleado', // Valor por defecto
      fechaContratacion: json['fecha_contratacion'] != null 
          ? DateTime.parse(json['fecha_contratacion']) 
          : DateTime.now(),
      activo: json['activo'] ?? true,
      idHorario: json['id_horario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empleado': id,
      'nombre': nombre,
      'apellido': apellido,
      'DNI': dni,
      'telefono': telefono,
      'telefono_emergencia': telefonoEmergencia,
      'email': email,
      'sexo': sexo,
      'rol': rol,
      'fecha_contratacion': fechaContratacion.toIso8601String().split('T')[0],
      'activo': activo,
      'id_horario': idHorario,
    };
  }
}