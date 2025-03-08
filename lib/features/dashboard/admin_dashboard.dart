import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/notification_badge.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/dashboard_card.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/theme_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ajustar para mejor visualización web
    final isWeb = Theme.of(context).platform == TargetPlatform.macOS ||
                 Theme.of(context).platform == TargetPlatform.windows ||
                 Theme.of(context).platform == TargetPlatform.linux;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          const NotificationBadge(count: 3),
          // Botón de tema
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                tooltip: themeProvider.isDarkMode 
                    ? 'Cambiar a modo claro' 
                    : 'Cambiar a modo oscuro',
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(isAdmin: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 1200 : double.infinity,
            ),
            child: GridView.count(
              crossAxisCount: Responsive.isDesktop(context) 
                ? 4 
                : (Responsive.isTablet(context) ? 3 : 2),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: isWeb ? 1.3 : 1.0,
              children: [
                DashboardCard(
                  icon: Icons.people_alt,
                  title: 'Empleados',
                  count: 24,
                  color: Colors.blueAccent,
                  onTap: () => Navigator.pushNamed(context, '/employees'),
                ),
                DashboardCard(
                  icon: Icons.attach_money,
                  title: 'Nóminas',
                  count: 12,
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/payroll'),
                ),
                DashboardCard(
                  icon: Icons.access_time,
                  title: 'Asistencias',
                  count: 45,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/attendance'),
                ),
                DashboardCard(
                  icon: Icons.bar_chart,
                  title: 'Reportes',
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}