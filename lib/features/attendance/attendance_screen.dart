import 'package:flutter/material.dart';
import 'widgets/attendance_calendar.dart';
import 'widgets/admin_attendance_list.dart';
import 'widgets/personal_attendance_history.dart';
import '../../core/widgets/custom_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = false; // O implementa tu AuthProvider para determinar el rol

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Asistencia'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Acciones adicionales si las necesitas
        ],
      ),
      // Drawer existente
      drawer: CustomDrawer(isAdmin: isAdmin),
      body: Column(
        children: [
          const AttendanceCalendar(),
          Expanded(
            child: isAdmin 
                ? const AdminAttendanceList() 
                : const PersonalAttendanceHistory(showSummary: false),
          ),
        ],
      ),
      floatingActionButton: !isAdmin ? FloatingActionButton(
        onPressed: () => _registerAttendance(context),
        child: const Icon(Icons.fingerprint),
      ) : null,
    );
  }

  void _registerAttendance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Asistencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Desea registrar su asistencia ahora?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(
                  DateTime.now().toString().substring(11, 16),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí iría la lógica para registrar la asistencia
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Asistencia registrada correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }
}