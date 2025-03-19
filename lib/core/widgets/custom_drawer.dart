import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  final bool isAdmin;

  const CustomDrawer({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                Text(
                  isAdmin ? 'Administrador' : 'Empleado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Tourist Options',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Empleados'),
              onTap: () {
                Navigator.pushNamed(context, '/employees');
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Nóminas'),
              onTap: () {
                Navigator.pushNamed(context, '/payroll');
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Mi Portal'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/employee');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Mi Asistencia'),
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  '/attendance', 
                  arguments: {'viewType': 'personal'}
                );
              },
            ),
            
          ],
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Asistencias'),
            onTap: () {
              Navigator.pushNamed(context, '/attendance');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reportes'),
            onTap: () {
              Navigator.pushNamed(context, '/reports');
            },
          ),
          ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Solicitudes'),
              onTap: () {
                Navigator.pushNamed(context, '/requests');
              },
            ),
          const Divider(),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                title: Text(
                  themeProvider.isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
                ),
                onTap: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Cambio de Contraseña'),
              onTap: () {
                Navigator.pushNamed(context, '/change_password');
              },
            ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}