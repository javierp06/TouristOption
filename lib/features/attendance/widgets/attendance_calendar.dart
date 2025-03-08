import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({Key? key}) : super(key: key);

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  late DateTime _currentMonth;
  late DateTime _previousMonth;
  late DateTime _previousTwoMonth;
  DateTime? _selectedDay;
  
  // Ejemplo de días con asistencia
  final Set<DateTime> _attendanceDays = {
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now().subtract(const Duration(days: 10)),
    DateTime.now().subtract(const Duration(days: 35)), // Mes anterior
    DateTime.now().subtract(const Duration(days: 65)), // Dos meses atrás
  };

  @override
  void initState() {
    super.initState();
    _initializeMonths();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _previousMonth = DateTime(now.year, now.month - 1, 1);
    _previousTwoMonth = DateTime(now.year, now.month - 2, 1);
  }

  void _navigateToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _previousMonth = DateTime(_previousMonth.year, _previousMonth.month - 1, 1);
      _previousTwoMonth = DateTime(_previousTwoMonth.year, _previousTwoMonth.month - 1, 1);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _previousMonth = DateTime(_previousMonth.year, _previousMonth.month + 1, 1);
      _previousTwoMonth = DateTime(_previousTwoMonth.year, _previousTwoMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar si mostrar en modo columna o fila basado en el ancho disponible
        final isWideLayout = constraints.maxWidth > 900;
        
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Registro de asistencia',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: _navigateToPreviousMonth,
                          tooltip: 'Mes anterior',
                          iconSize: 18,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: _navigateToNextMonth,
                          tooltip: 'Mes siguiente',
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isWideLayout)
                // Layout horizontal para pantallas anchas
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildMonthCalendar(_previousTwoMonth, constraints.maxWidth / (isWideLayout ? 4 : 1.2)),
                            _buildMonthCalendar(_previousMonth, constraints.maxWidth / (isWideLayout ? 4 : 1.2)),
                            _buildMonthCalendar(_currentMonth, constraints.maxWidth / (isWideLayout ? 4 : 1.2)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildAttendanceSummary(),
                    ),
                  ],
                )
              else
                // Layout vertical para pantallas estrechas
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildMonthCalendar(_previousTwoMonth, constraints.maxWidth / 1.2),
                          _buildMonthCalendar(_previousMonth, constraints.maxWidth / 1.2),
                          _buildMonthCalendar(_currentMonth, constraints.maxWidth / 1.2),
                        ],
                      ),
                    ),
                    _buildAttendanceSummary(),
                  ],
                ),
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildMonthCalendar(DateTime focusedMonth, double width) {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime(2020, 1, 1),
          lastDay: DateTime(2030, 12, 31),
          focusedDay: focusedMonth,
          currentDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mes',
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: false,
            rightChevronVisible: false,
          ),
          daysOfWeekHeight: 20,
          rowHeight: 35,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: const TextStyle(color: Colors.red),
            holidayTextStyle: const TextStyle(color: Colors.red),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            cellMargin: const EdgeInsets.all(2),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (_attendanceDays.contains(DateTime(date.year, date.month, date.day))) {
                return Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    width: 7,
                    height: 7,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen del Mes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Divider(),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Horas este mes:'),
                  Text('156.5 / 160 hrs', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Días trabajados:'),
                  Text('21 / 22 días', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Llegadas tarde:'),
                  Text('2', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ausencias:'),
                  Text('1', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: const Column(
                  children: [
                    Text('Próximo día libre', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Viernes, 15 de marzo', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}