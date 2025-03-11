class Employee {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String dni;
  final String telefonoEmergencia;
  final String sexo;
  final String email;
  final String rol;
  final DateTime fechaContratacion;
  final int hoursWorked; // Keep backward compatibility
  final DateTime lastAttendance; // Keep backward compatibility
  final String position; // Keep backward compatibility
  
  Employee({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.dni,
    required this.telefonoEmergencia,
    required this.sexo,
    required this.email,
    required this.rol,
    required this.fechaContratacion,
    this.hoursWorked = 0,
    DateTime? lastAttendance,
    String? position,
  }) : 
    this.lastAttendance = lastAttendance ?? DateTime.now(),
    this.position = position ?? rol;
    
  // For display purposes
  String get name => '$nombre $apellido';
  
  // Create from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id_empleado'].toString(),
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      telefono: json['telefono'] ?? '',
      dni: json['DNI'] ?? '',
      telefonoEmergencia: json['telefono_emergencia'] ?? '',
      sexo: json['sexo'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? '',
      fechaContratacion: json['fecha_contratacion'] != null 
          ? DateTime.parse(json['fecha_contratacion']) 
          : DateTime.now(),
    );
  }
}