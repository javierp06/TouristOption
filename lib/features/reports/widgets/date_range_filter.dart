import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeFilter extends StatelessWidget {
  final DateTimeRange dateRange;
  final Function(DateTimeRange) onDateRangeChanged;

  const DateRangeFilter({
    Key? key,
    required this.dateRange,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Período',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDateRange: dateRange,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (result != null) {
              onDateRangeChanged(result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}',
                ),
                const Icon(Icons.calendar_today_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickDateButton(
              label: 'Última Semana',
              onPressed: () {
                final today = DateTime.now();
                final lastWeek = today.subtract(const Duration(days: 7));
                onDateRangeChanged(DateTimeRange(start: lastWeek, end: today));
              },
            ),
            _QuickDateButton(
              label: 'Último Mes',
              onPressed: () {
                final today = DateTime.now();
                final lastMonth = DateTime(today.year, today.month - 1, today.day);
                onDateRangeChanged(DateTimeRange(start: lastMonth, end: today));
              },
            ),
            _QuickDateButton(
              label: 'Este Año',
              onPressed: () {
                final today = DateTime.now();
                final startOfYear = DateTime(today.year, 1, 1);
                onDateRangeChanged(DateTimeRange(start: startOfYear, end: today));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _QuickDateButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}