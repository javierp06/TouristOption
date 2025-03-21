import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/payroll.dart';

class PayrollDetailScreen extends StatelessWidget {
  final Payroll payroll;
  
  const PayrollDetailScreen({
    Key? key,
    required this.payroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_HN',
      symbol: 'L',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Nómina'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Información General',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusBadge(payroll.estado),
                      ],
                    ),
                    const Divider(),
                    _buildInfoRow('Empleado', payroll.empleadoNombre),
                    _buildInfoRow('Período', payroll.periodo),
                    _buildInfoRow(
                      'Fecha de Generación', 
                      DateFormat('dd/MM/yyyy').format(payroll.fechaGeneracion)
                    ),
                  ],
                ),
              ),
            ),
            
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desglose de Salario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildSalaryRow(
                      'Salario Base', 
                      payroll.salarioBruto - payroll.horasExtra, 
                      currencyFormat
                    ),
                    _buildSalaryRow(
                      'Horas Extra', 
                      payroll.horasExtra, 
                      currencyFormat
                    ),
                    _buildSalaryRow(
                      'Bonificaciones', 
                      payroll.bonificaciones, 
                      currencyFormat
                    ),
                    const Divider(),
                    _buildSalaryRow(
                      'Salario Bruto', 
                      payroll.salarioBruto, 
                      currencyFormat,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
            
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deducciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildSalaryRow(
                      'RAP (4%)', 
                      payroll.deduccionRap, 
                      currencyFormat,
                      isNegative: true
                    ),
                    _buildSalaryRow(
                      'IHSS (2.5%)', 
                      payroll.deduccionIhss, 
                      currencyFormat,
                      isNegative: true
                    ),
                    const Divider(),
                    _buildSalaryRow(
                      'Total Deducciones', 
                      payroll.deduccionRap + payroll.deduccionIhss, 
                      currencyFormat,
                      isNegative: true,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
            
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Salario Neto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormat.format(payroll.salarioNeto),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSalaryRow(
    String label, 
    double amount, 
    NumberFormat formatter, 
    {bool isNegative = false, bool isBold = false}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            isNegative ? '- ${formatter.format(amount)}' : formatter.format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isNegative ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'en proceso':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'transferido':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rechazado':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.blue;
        icon = Icons.info;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}