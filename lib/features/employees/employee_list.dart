import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/employee.dart';
import '../../core/widgets/custom_data_table.dart';
import '../../core/widgets/search_bar.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  // Datos de ejemplo - en una app real vendrían de una API o base de datos
  final List<Employee> employees = [
    Employee(
      id: '1',
      name: 'Juan Pérez',
      position: 'Guía Turístico',
      hoursWorked: 40,
      lastAttendance: DateTime.now().subtract(const Duration(days: 1)),
      email: 'juan@touristoptions.com',
      phone: '9999-8888',
    ),
    Employee(
      id: '2',
      name: 'María García',
      position: 'Administradora',
      hoursWorked: 38,
      lastAttendance: DateTime.now(),
      email: 'maria@touristoptions.com',
      phone: '9999-7777',
    ),
    Employee(
      id: '3',
      name: 'Carlos Rodríguez',
      position: 'Conductor',
      hoursWorked: 45,
      lastAttendance: DateTime.now().subtract(const Duration(days: 2)),
      email: 'carlos@touristoptions.com',
      phone: '9999-6666',
    ),
  ];

  List<Employee> filteredEmployees = [];
  
  @override
  void initState() {
    super.initState();
    filteredEmployees = [...employees];
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = [...employees];
      } else {
        filteredEmployees = employees
            .where((employee) =>
                employee.name.toLowerCase().contains(query.toLowerCase()) ||
                employee.position.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Nuevo Empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Puesto'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí iría la lógica para añadir un nuevo empleado
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Empleado añadido correctamente')),
              );
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchWidget(onSearch: _filterEmployees),
          ),
          Expanded(
            child: CustomDataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Puesto')),
                DataColumn(label: Text('Horas Trabajadas')),
                DataColumn(label: Text('Última Asistencia')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: filteredEmployees.map((employee) => DataRow(
                cells: [
                  DataCell(Text(employee.name)),
                  DataCell(Text(employee.position)),
                  DataCell(Text('${employee.hoursWorked} hrs')),
                  DataCell(Text(DateFormat('dd/MM/yyyy').format(employee.lastAttendance))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: _showAddEmployeeDialog,
      ),
    );
  }
}