import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/models/employee.dart';
import '../../core/widgets/custom_data_table.dart';
import '../../core/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  bool _isLoading = true;
  String? _token;
  
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _telefonoEmergenciaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  DateTime _fechaContratacion = DateTime.now();
  String _sexoSeleccionado = 'Masculino';

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      _fetchEmployees();
    });
  }
  
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }
  
  Future<void> _fetchEmployees() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final url = Uri.parse('https://timecontrol-backend.onrender.com/empleados');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        
        setState(() {
          employees = responseData.map((data) => Employee.fromJson(data)).toList();
          filteredEmployees = [...employees];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar empleados: $error')),
      );
    }
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = [...employees];
      } else {
        filteredEmployees = employees
            .where((employee) =>
                employee.name.toLowerCase().contains(query.toLowerCase()) ||
                employee.rol.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  void _showAddEmployeeDialog() {
    // Reset form fields
    _nombreController.clear();
    _apellidoController.clear();
    _telefonoController.clear();
    _dniController.clear();
    _telefonoEmergenciaController.clear();
    _emailController.clear();
    _rolController.clear();
    _fechaContratacion = DateTime.now();
    _sexoSeleccionado = 'Masculino';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Nuevo Empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _dniController,
                decoration: const InputDecoration(labelText: 'DNI'),
              ),
              TextField(
                controller: _telefonoEmergenciaController,
                decoration: const InputDecoration(labelText: 'Teléfono de Emergencia'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _rolController,
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              DropdownButton<String>(
                value: _sexoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _sexoSeleccionado = newValue!;
                  });
                },
                items: <String>['Masculino', 'Femenino', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Fecha contratación: ${DateFormat('dd/MM/yyyy').format(_fechaContratacion)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaContratacion,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _fechaContratacion) {
                        setState(() {
                          _fechaContratacion = picked;
                        });
                      }
                    },
                  ),
                ],
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
              _saveEmployee();
              Navigator.of(context).pop();
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEmployee() async {
    try {
      final url = Uri.parse('https://timecontrol-backend.onrender.com/empleados');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'telefono': _telefonoController.text,
          'dni': _dniController.text,
          'telefono_emergencia': _telefonoEmergenciaController.text,
          'sexo': _sexoSeleccionado,
          'email': _emailController.text,
          'rol': _rolController.text,
          'id_horario': 1,
          'fecha_contratacion': DateFormat('yyyy-MM-dd').format(_fechaContratacion),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final responseData = json.decode(response.body);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado añadido correctamente')),
        );
        
        // Refresh employee list
        _fetchEmployees();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $error')),
      );
    }
  }

  Future<void> _updateEmployee(String employeeId) async {
    try {
      final url = Uri.parse('https://timecontrol-backend.onrender.com/empleados/$employeeId');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'telefono': _telefonoController.text,
          'dni': _dniController.text,
          'telefono_emergencia': _telefonoEmergenciaController.text,
          'sexo': _sexoSeleccionado,
          'email': _emailController.text,
          'rol': _rolController.text,
          'id_horario': 1,
          'fecha_contratacion': DateFormat('yyyy-MM-dd').format(_fechaContratacion),
        }),
      );

      if (response.statusCode == 200) {
        // Success
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado actualizado correctamente')),
        );
        
        // Refresh employee list
        _fetchEmployees();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $error')),
      );
    }
  }

  void _showEditEmployeeDialog(Employee employee) {
    // Pre-fill form fields with employee data
    _nombreController.text = employee.nombre;
    _apellidoController.text = employee.apellido;
    _telefonoController.text = employee.telefono;
    _dniController.text = employee.dni;
    _telefonoEmergenciaController.text = employee.telefonoEmergencia;
    _emailController.text = employee.email;
    _rolController.text = employee.rol;
    _fechaContratacion = employee.fechaContratacion;
    _sexoSeleccionado = employee.sexo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _dniController,
                decoration: const InputDecoration(labelText: 'DNI'),
              ),
              TextField(
                controller: _telefonoEmergenciaController,
                decoration: const InputDecoration(labelText: 'Teléfono de Emergencia'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _rolController,
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              DropdownButton<String>(
                value: _sexoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _sexoSeleccionado = newValue!;
                  });
                },
                items: <String>['Masculino', 'Femenino', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Fecha contratación: ${DateFormat('dd/MM/yyyy').format(_fechaContratacion)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaContratacion,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _fechaContratacion) {
                        setState(() {
                          _fechaContratacion = picked;
                        });
                      }
                    },
                  ),
                ],
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
              _updateEmployee(employee.id);
              Navigator.of(context).pop();
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar a ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteEmployee(employee.id);
              Navigator.of(context).pop();
            },
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEmployee(String id_empleado) async {
    try {
      final url = Uri.parse('https://timecontrol-backend.onrender.com/empleados/$id_empleado');
      
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado eliminado correctamente')),
        );
        
        // Refresh employee list
        _fetchEmployees();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEmployees,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchWidget(onSearch: _filterEmployees),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredEmployees.isEmpty
                ? const Center(child: Text('No hay empleados disponibles'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CustomDataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('DNI')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Teléfono')),
                        DataColumn(label: Text('T. Emergencia')),
                        DataColumn(label: Text('Sexo')),
                        DataColumn(label: Text('Rol')),
                        DataColumn(label: Text('F. Contratación')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: filteredEmployees.map((employee) => DataRow(
                        cells: [
                          DataCell(Text(employee.name)),
                          DataCell(Text(employee.dni)),
                          DataCell(Text(employee.email)),
                          DataCell(Text(employee.telefono)),
                          DataCell(Text(employee.telefonoEmergencia)),
                          DataCell(Text(employee.sexo)),
                          DataCell(Text(employee.rol)),
                          DataCell(Text(DateFormat('dd/MM/yyyy').format(employee.fechaContratacion))),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditEmployeeDialog(employee);
                                },
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmation(employee);
                                },
                                tooltip: 'Eliminar',
                              ),
                            ],
                          )),
                        ],
                      )).toList(),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: _showAddEmployeeDialog,
        tooltip: 'Añadir empleado',
      ),
    );
  }
}