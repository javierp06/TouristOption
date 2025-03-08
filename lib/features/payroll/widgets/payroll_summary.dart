import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayrollSummary extends StatelessWidget {
  final double totalAmount;
  final int pendingCount;

  const PayrollSummary({
    Key? key,
    required this.totalAmount,
    required this.pendingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryCard(
            icon: Icons.attach_money,
            title: 'Total Nómina',
            value: 'L. ${NumberFormat("#,##0.00").format(totalAmount)}',
            color: Colors.green,
          ),
          _SummaryCard(
            icon: Icons.pending_actions,
            title: 'Pendientes',
            value: pendingCount.toString(),
            color: Colors.orange,
          ),
          _SummaryCard(
            icon: Icons.people,
            title: 'Empleados',
            value: '3', // Esto debería ser dinámico
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}