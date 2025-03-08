import 'package:flutter/material.dart';

class PayrollFilter extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const PayrollFilter({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final periods = [
      'Mayo 2025',
      'Abril 2025',
      'Marzo 2025',
      'Febrero 2025',
      'Enero 2025',
      'Diciembre 2024',
    ];

    return Container(
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
          const Text(
            'Selecciona un período',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: selectedPeriod,
            items: periods.map((String period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(period),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onPeriodChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}