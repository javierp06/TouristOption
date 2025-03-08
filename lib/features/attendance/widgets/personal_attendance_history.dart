import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalAttendanceHistory extends StatelessWidget {
  final bool showSummary;
  
  const PersonalAttendanceHistory({Key? key, this.showSummary = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para un empleado
    final attendanceRecords = [
      {
        'date': DateTime.now().subtract(const Duration(days: 0)),
        'checkIn': '08:02',
        'checkOut': '17:05',
        'status': 'Presente',
        'hoursWorked': 9.05,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'checkIn': '07:55',
        'checkOut': '17:00',
        'status': 'Presente',
        'hoursWorked': 9.08,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'checkIn': '--:--',
        'checkOut': '--:--',
        'status': 'Ausente',
        'hoursWorked': 0,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'checkIn': '08:10',
        'checkOut': '16:45',
        'status': 'Presente',
        'hoursWorked': 8.58,
      },
    ];

    // La clave está en usar un widget Container o SizedBox.expand como raíz
    // para asegurar que ocupe todo el espacio disponible
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mi Historial de Asistencia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (showSummary) _buildSummary(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = attendanceRecords[index];
                  return _buildAttendanceCard(context, record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Horas este mes:'),
                Text('156.5 / 160 hrs', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 156.5 / 160,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryItem(title: 'Llegadas a tiempo', value: '20'),
                _SummaryItem(title: 'Llegadas tarde', value: '2'),
                _SummaryItem(title: 'Ausencias', value: '1'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, Map<String, dynamic> record) {
    final isPresent = record['status'] == 'Presente';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPresent ? Colors.green : Colors.red,
          child: Icon(
            isPresent ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(DateFormat('EEEE, d MMM').format(record['date'] as DateTime)),
        subtitle: Text(
          'Entrada: ${record['checkIn']} | Salida: ${record['checkOut']}\n'
          'Horas: ${record['hoursWorked']} hrs',
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}