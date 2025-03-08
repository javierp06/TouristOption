import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayrollList extends StatelessWidget {
  final List<Map<String, dynamic>> payrollData;
  final bool isAdmin;
  final Function(Map<String, dynamic>) onSelectPayroll;
  final Function(BuildContext, Map<String, dynamic>) onViewDetails;
  final Map<String, dynamic>? selectedPayroll;

  const PayrollList({
    Key? key,
    required this.payrollData,
    required this.isAdmin,
    required this.onSelectPayroll,
    required this.onViewDetails,
    this.selectedPayroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (payrollData.isEmpty) {
      return const Center(
        child: Text('No hay datos de nómina disponibles para este período'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payrollData.length,
      itemBuilder: (context, index) {
        final payroll = payrollData[index];
        final isSelected = selectedPayroll != null && 
                          selectedPayroll!['id'] == payroll['id'];
                          
        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected 
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2) 
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => onSelectPayroll(payroll),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isAdmin)
                            Text(
                              payroll['employeeName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          Text(
                            'Recibo de pago - ${payroll['period']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusBadge(payroll['status']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Neto'),
                          Text(
                            'L. ${NumberFormat("#,##0.00").format(payroll['netSalary'])}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => onViewDetails(context, payroll),
                        child: const Text('Ver Detalles'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pagado':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'procesando':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}