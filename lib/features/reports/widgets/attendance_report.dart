import 'package:flutter/material.dart';
import 'monthly_attendance_summary.dart';

class AttendanceReport extends StatelessWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add the monthly summary at the top
        const MonthlyAttendanceSummary(),
        
        const SizedBox(height: 24),
        
        // Gráfico de barras para asistencia (simulado)
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen de Asistencia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar('Lun', 0.9, Colors.blue, constraints.maxHeight),
                        _buildBar('Mar', 0.8, Colors.blue, constraints.maxHeight),
                        _buildBar('Mié', 0.95, Colors.blue, constraints.maxHeight),
                        _buildBar('Jue', 0.85, Colors.blue, constraints.maxHeight),
                        _buildBar('Vie', 0.75, Colors.blue, constraints.maxHeight),
                        _buildBar('Sáb', 0.5, Colors.blue, constraints.maxHeight),
                        _buildBar('Dom', 0.3, Colors.blue, constraints.maxHeight),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Resumen de estadísticas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estadísticas de Asistencia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Asistencias', '85%', Colors.green),
                  _buildStat('Tardanzas', '10%', Colors.orange),
                  _buildStat('Ausencias', '5%', Colors.red),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Tabla detallada
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Empleados con más Ausencias',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Empleado')),
                    DataColumn(label: Text('Ausencias')),
                    DataColumn(label: Text('Tardanzas')),
                    DataColumn(label: Text('% Asistencia')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Carlos Rodríguez')),
                      DataCell(Text('3')),
                      DataCell(Text('5')),
                      DataCell(Text('80%')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('María García')),
                      DataCell(Text('1')),
                      DataCell(Text('2')),
                      DataCell(Text('95%')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Juan Pérez')),
                      DataCell(Text('0')),
                      DataCell(Text('3')),
                      DataCell(Text('97%')),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, double percentage, Color color, double maxHeight) {
    final height = (maxHeight - 40) * percentage;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStat(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}