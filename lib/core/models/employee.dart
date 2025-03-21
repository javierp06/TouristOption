class Employee {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String email;
  final String telefono;
  final String telefonoEmergencia;
  final String sexo;
  final String rol;
  final DateTime fechaContratacion;
  final double salario; // Nuevo campo
  final bool? activo;

  Employee({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.email,
    required this.telefono,
    required this.telefonoEmergencia,
    required this.sexo,
    required this.rol,
    required this.fechaContratacion,
    required this.salario, // Nuevo campo
    this.activo,
  });

  // For display purposes
  String get name => '$nombre $apellido';

  // Create from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      nombre: json['nombre'],
      apellido: json['apellido'],
      dni: json['dni'],
      email: json['email'],
      telefono: json['telefono'],
      telefonoEmergencia: json['telefonoEmergencia'],
      sexo: json['sexo'],
      rol: json['rol'],
      fechaContratacion: DateTime.parse(json['fechaContratacion']),
      salario: double.tryParse(json['salario']?.toString() ?? '0') ?? 0.0, // Nuevo campo
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'email': email,
      'telefono': telefono,
      'telefonoEmergencia': telefonoEmergencia,
      'sexo': sexo,
      'rol': rol,
      'fechaContratacion': fechaContratacion.toIso8601String().split('T')[0],
      'salario': salario, // Nuevo campo
      'activo': activo,
    };
  }
}