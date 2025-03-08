import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/report_selector.dart';
import 'widgets/date_range_filter.dart';
import 'widgets/attendance_report.dart';
import 'widgets/performance_report.dart';
import 'widgets/payroll_report.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedReport = 'Asistencia';
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  bool isAdmin = true; // Cambiar según el rol del usuario
  bool _isLoading = false;

  // Lista de reportes disponibles
  final List<String> reports = ['Asistencia', 'Rendimiento', 'Nóminas'];

  // Función para cambiar el reporte seleccionado
  void _changeReport(String report) {
    setState(() {
      selectedReport = report;
      _isLoading = true;
    });

    // Simulamos carga de datos
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // Función para actualizar el rango de fechas
  void _updateDateRange(DateTimeRange range) {
    setState(() {
      dateRange = range;
      _isLoading = true;
    });

    // Simulamos carga de datos
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // Función para exportar el reporte
  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exportando reporte de $selectedReport...'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Exportar reporte',
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar datos',
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtros y selectores
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                // Selector de tipo de reporte
                ReportSelector(
                  reports: reports,
                  selectedReport: selectedReport,
                  onReportChanged: _changeReport,
                ),
                const SizedBox(height: 16),
                // Filtro de rango de fechas
                DateRangeFilter(
                  dateRange: dateRange,
                  onDateRangeChanged: _updateDateRange,
                ),
              ],
            ),
          ),

          // Información del reporte seleccionado
          // Reemplazar el Row actual con:
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              // Cambiado de Row a Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reporte de $selectedReport',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4), // Espaciado vertical
                Text(
                  '(${DateFormat('dd/MM/yyyy').format(dateRange.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange.end)})',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Contenido del reporte (gráficos y datos)
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildReportContent(),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    switch (selectedReport) {
      case 'Asistencia':
        return const AttendanceReport();
      case 'Rendimiento':
        return const PerformanceReport();
      case 'Nóminas':
        return const PayrollReport(period: '');
      default:
        return const Center(child: Text('Reporte no disponible'));
    }
  }
}
