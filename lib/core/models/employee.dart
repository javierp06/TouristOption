class Employee {
  final String id;
  final String name;
  final String position;
  final int hoursWorked;
  final DateTime lastAttendance;
  final String email;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.hoursWorked,
    required this.lastAttendance,
    required this.email,
    required this.phone,
  });
}