import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/attendance/admin_attendance_register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'widgets/attendance_calendar.dart';
import 'widgets/personal_attendance_history.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/models/employee.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isAdmin = true; // En producción: determinar basado en JWT o provider
  Employee? selectedEmployee;
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    
    // Agregar listener para la búsqueda
    searchController.addListener(() {
      _filterEmployees(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = List.from(employees);
      } else {
        filteredEmployees = employees
            .where((employee) =>
                '${employee.nombre} ${employee.apellido}'
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                employee.dni.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchEmployees() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      
      final response = await http.get(
        Uri.parse('https://timecontrol-backend.onrender.com/empleados'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final loadedEmployees = responseData
            .map((data) => Employee.fromJson(data))
            .toList();
        
        setState(() {
          employees = loadedEmployees;
          filteredEmployees = loadedEmployees;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar empleados: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error de conexión: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin 
            ? selectedEmployee != null 
                ? 'Asistencia de ${selectedEmployee!.nombre} ${selectedEmployee!.apellido}'
                : 'Gestión de Asistencia'
            : 'Mi Registro de Asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (selectedEmployee == null) {
                _fetchEmployees();
              }
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      drawer: const CustomDrawer(isAdmin: true),
      body: isAdmin
          ? _buildAdminView(isWideScreen)
          : _buildEmployeeView(isWideScreen),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminAttendanceRegister()),
              );
            },
            label: const Text('Registrar Asistencia'),
            icon: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildAdminView(bool isWideScreen) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchEmployees,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (selectedEmployee == null) {
      // Mostrar lista de empleados para seleccionar
      return _buildEmployeeSelector();
    } else {
      // Mostrar detalles del empleado seleccionado
      return Column(
        children: [
          // Barra superior con botón para volver a la lista
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      selectedEmployee = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Volver a la lista de empleados',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          // Vista detallada del empleado
          Expanded(
            child: isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: PersonalAttendanceHistory(
                          showSummary: true,
                          employeeId: selectedEmployee!.id,
                          employeeName: '${selectedEmployee!.nombre} ${selectedEmployee!.apellido}',
                        ),
                      ),
                      const Expanded(
                        flex: 4,
                        child: AttendanceCalendar(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: PersonalAttendanceHistory(
                          showSummary: true,
                          employeeId: selectedEmployee!.id,
                          employeeName: '${selectedEmployee!.nombre} ${selectedEmployee!.apellido}',
                        ),
                      ),
                      const Expanded(
                        flex: 6,
                        child: AttendanceCalendar(),
                      ),
                    ],
                  ),
          ),
        ],
      );
    }
  }

  Widget _buildEmployeeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccione un empleado para ver su registro de asistencia',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar empleado...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          filteredEmployees.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Text('No se encontraron empleados'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              employee.nombre.isNotEmpty ? employee.nombre[0] : "",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text('${employee.nombre} ${employee.apellido}'),
                          subtitle: Text('${employee.email} • ${employee.telefono}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => setState(() {
                            selectedEmployee = employee;
                          }),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmployeeView(bool isWideScreen) {
    return isWideScreen
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                flex: 4,
                child: PersonalAttendanceHistory(showSummary: true),
              ),
              Expanded(
                flex: 4,
                child: AttendanceCalendar(),
              ),
            ],
          )
        : Column(
            children: const [
              Expanded(
                flex: 4,
                child: PersonalAttendanceHistory(showSummary: true),
              ),
              Expanded(
                flex: 6,
                child: AttendanceCalendar(),
              ),
            ],
          );
          

  }
  
}