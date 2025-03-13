import 'package:flutter/material.dart';
import '../../core/widgets/custom_drawer.dart';
import 'widgets/request_form.dart';
import 'widgets/request_list.dart';
import 'models/request.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  String? errorMessage;
  
  // Lista de ejemplo de solicitudes
  final List<Request> _requests = [
    Request(
      id: '1',
      type: RequestType.permission,
      status: RequestStatus.approved,
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 4)),
      reason: 'Cita médica',
      comments: 'Aprobado por supervisor directo',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Request(
      id: '2',
      type: RequestType.overtime,
      status: RequestStatus.pending,
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      hours: 3,
      reason: 'Cierre de inventario mensual',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Request(
      id: '3',
      type: RequestType.vacation,
      status: RequestStatus.rejected,
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 24)),
      reason: 'Vacaciones familiares',
      comments: 'Rechazado por periodo ocupado',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Request(
      id: '4',
      type: RequestType.disability,
      status: RequestStatus.approved,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      reason: 'Incapacidad por enfermedad',
      attachmentUrl: 'https://example.com/documents/incapacidad.pdf',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _createNewRequest(Request request) {
    setState(() {
      _requests.insert(0, request.copyWith(
        id: (_requests.length + 1).toString(), 
        status: RequestStatus.pending,
        createdAt: DateTime.now()
      ));
    });
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Solicitud enviada exitosamente'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Permisos'),
            Tab(text: 'Horas Extra'),
            Tab(text: 'Vacaciones'),
            Tab(text: 'Incapacidad'),
          ],
        ),
      ),
      drawer: const CustomDrawer(isAdmin: false),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Permisos
                _buildRequestTab(RequestType.permission),
                // Horas extra
                _buildRequestTab(RequestType.overtime),
                // Vacaciones
                _buildRequestTab(RequestType.vacation),
                // Incapacidad
                _buildRequestTab(RequestType.disability),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRequestForm(context),
        child: const Icon(Icons.add),
        tooltip: 'Nueva solicitud',
      ),
    );
  }

  Widget _buildRequestTab(RequestType type) {
    final filteredRequests = _requests.where((request) => request.type == type).toList();
    
    return filteredRequests.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No hay solicitudes de ${_getRequestTypeName(type)} registradas',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : RequestList(requests: filteredRequests);
  }

  void _showRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return RequestForm(
            scrollController: scrollController,
            initialType: _tabController.index == 0 
                ? RequestType.permission 
                : _tabController.index == 1 
                    ? RequestType.overtime 
                    : _tabController.index == 2 
                        ? RequestType.vacation 
                        : RequestType.disability,
            onSubmit: _createNewRequest,
          );
        },
      ),
    );
  }

  String _getRequestTypeName(RequestType type) {
    switch (type) {
      case RequestType.permission:
        return 'permisos';
      case RequestType.overtime:
        return 'horas extra';
      case RequestType.vacation:
        return 'vacaciones';
      case RequestType.disability:
        return 'incapacidad';
    }
  }
}