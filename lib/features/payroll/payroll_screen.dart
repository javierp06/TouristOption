import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/payroll_filter.dart';
import 'widgets/payroll_list.dart';
import 'widgets/payroll_summary.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({Key? key}) : super(key: key);

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  String selectedPeriod = 'Mayo 2025';
  bool isAdmin = false; // Cambiar según la autenticación real
  
  final List<Map<String, dynamic>> payrollData = [
    {
      'id': '001',
      'employeeId': '1',
      'employeeName': 'Juan Pérez',
      'period': 'Mayo 2025',
      'grossSalary': 15000.0,
      'deductions': 3250.0,
      'netSalary': 11750.0,
      'status': 'Pagado',
      'date': DateTime(2025, 5, 30),
      'details': {
        'baseSalary': 12000.0,
        'overtime': 1000.0,
        'bonus': 2000.0,
        'ihss': 450.0,
        'isr': 2000.0,
        'advances': 800.0,
      }
    },
    {
      'id': '002',
      'employeeId': '2',
      'employeeName': 'María García',
      'period': 'Mayo 2025',
      'grossSalary': 18000.0,
      'deductions': 4100.0,
      'netSalary': 13900.0,
      'status': 'Pagado',
      'date': DateTime(2025, 5, 30),
      'details': {
        'baseSalary': 15000.0,
        'overtime': 1500.0,
        'bonus': 1500.0,
        'ihss': 600.0,
        'isr': 2500.0,
        'advances': 1000.0,
      }
    },
    {
      'id': '003',
      'employeeId': '3',
      'employeeName': 'Carlos Rodríguez',
      'period': 'Mayo 2025',
      'grossSalary': 12000.0,
      'deductions': 2400.0,
      'netSalary': 9600.0,
      'status': 'Procesando',
      'date': DateTime(2025, 5, 30),
      'details': {
        'baseSalary': 10000.0,
        'overtime': 500.0,
        'bonus': 1500.0,
        'ihss': 400.0,
        'isr': 1500.0,
        'advances': 500.0,
      }
    },
  ];

  List<Map<String, dynamic>> filteredPayroll = [];
  Map<String, dynamic>? selectedPayroll;

  @override
  void initState() {
    super.initState();
    filteredPayroll = [...payrollData];
    if (filteredPayroll.isNotEmpty) {
      selectedPayroll = filteredPayroll[0];
    }
  }

  void _filterPayroll(String period) {
    setState(() {
      selectedPeriod = period;
      filteredPayroll = payrollData.where((p) => p['period'] == period).toList();
      if (filteredPayroll.isNotEmpty) {
        selectedPayroll = filteredPayroll[0];
      } else {
        selectedPayroll = null;
      }
    });
  }

  void _selectPayroll(Map<String, dynamic> payroll) {
    setState(() {
      selectedPayroll = payroll;
    });
  }

  void _showPayrollDetails(BuildContext context, Map<String, dynamic> payroll) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final details = payroll['details'] as Map<String, dynamic>;
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recibo de Pago', 
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: () {
                          // Implementar función para imprimir o descargar PDF
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recibo descargado'))
                          );
                        },
                      )
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Empleado'),
                    subtitle: Text(payroll['employeeName']),
                    leading: const Icon(Icons.person),
                  ),
                  ListTile(
                    title: const Text('Fecha de Pago'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(payroll['date'])),
                    leading: const Icon(Icons.calendar_today),
                  ),
                  ListTile(
                    title: const Text('Período'),
                    subtitle: Text(payroll['period']),
                    leading: const Icon(Icons.date_range),
                  ),
                  const SizedBox(height: 16),
                  Text('Ingresos', 
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  _buildPayrollItem('Salario Base', details['baseSalary']),
                  _buildPayrollItem('Horas Extra', details['overtime']),
                  _buildPayrollItem('Bonificaciones', details['bonus']),
                  const Divider(),
                  Text('Deducciones', 
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  _buildPayrollItem('IHSS', details['ihss'], isDeduction: true),
                  _buildPayrollItem('ISR', details['isr'], isDeduction: true),
                  _buildPayrollItem('Adelantos', details['advances'], isDeduction: true),
                  const Divider(thickness: 1.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Bruto:', 
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'L. ${NumberFormat("#,##0.00").format(payroll['grossSalary'])}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Deducciones:', 
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'L. ${NumberFormat("#,##0.00").format(payroll['deductions'])}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Neto:', 
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'L. ${NumberFormat("#,##0.00").format(payroll['netSalary'])}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayrollItem(String title, double amount, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            'L. ${NumberFormat("#,##0.00").format(amount)}',
            style: TextStyle(
              color: isDeduction ? Colors.red : Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nómina'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Implementar generación de nueva nómina
              },
            ),
        ],
      ),
      body: Column(
        children: [
          PayrollFilter(
            selectedPeriod: selectedPeriod,
            onPeriodChanged: _filterPayroll,
          ),
          if (isAdmin) 
            PayrollSummary(
              totalAmount: filteredPayroll.fold(
                0, (sum, item) => sum + (item['netSalary'] as double)
              ),
              pendingCount: filteredPayroll.where(
                (p) => p['status'] == 'Procesando'
              ).length,
            ),
          Expanded(
            child: PayrollList(
              payrollData: filteredPayroll,
              isAdmin: isAdmin,
              onSelectPayroll: _selectPayroll,
              onViewDetails: _showPayrollDetails,
              selectedPayroll: selectedPayroll,
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () {
          // Implementar exportación de nómina
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exportando nómina...'))
          );
        },
        child: const Icon(Icons.file_download),
      ) : null,
    );
  }
}