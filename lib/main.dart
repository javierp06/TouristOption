import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/requests/requests_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Añadir esta importación
import 'features/auth/login_screen.dart';
import 'features/dashboard/admin_dashboard.dart';
import 'features/dashboard/employee_dashboard.dart';
import 'features/employees/employee_list.dart';
import 'features/payroll/payroll_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/reports/reports_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/change_password_screen.dart';
import 'package:file_picker/file_picker.dart';  // Add this import


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await initializeDateFormatting('es');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TouristOptionsApp(),
    ),
  );
}

class TouristOptionsApp extends StatelessWidget {
  const TouristOptionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tourist Options - Employee Monitoring',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/admin': (context) => AdminDashboard(),
            '/employee': (context) => const EmployeeDashboard(),
            '/employees': (context) => EmployeeList(),
            '/payroll': (context) => const PayrollScreen(),
            '/attendance': (context) => const AttendanceScreen(),
            '/reports': (context) => const ReportsScreen(),
            '/requests': (context) => const RequestsScreen(),
            '/change_password': (context) => const ChangePasswordScreen(),
          },
        );
      }
    );
  }
}