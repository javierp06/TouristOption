import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/request.dart';

class RequestForm extends StatefulWidget {
  final ScrollController scrollController;
  final RequestType initialType;
  final Function(Request) onSubmit;

  const RequestForm({
    Key? key,
    required this.scrollController,
    required this.initialType,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  late RequestType _selectedType;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String? _attachmentName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nueva Solicitud',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Tipo de solicitud
            DropdownButtonFormField<RequestType>(
              decoration: const InputDecoration(
                labelText: 'Tipo de Solicitud',
                border: OutlineInputBorder(),
              ),
              value: _selectedType,
              onChanged: (RequestType? value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
              items: [
                DropdownMenuItem(
                  value: RequestType.permission,
                  child: const Text('Permiso'),
                ),
                DropdownMenuItem(
                  value: RequestType.overtime,
                  child: const Text('Horas Extra'),
                ),
                DropdownMenuItem(
                  value: RequestType.vacation,
                  child: const Text('Vacaciones'),
                ),
                DropdownMenuItem(
                  value: RequestType.disability,
                  child: const Text('Incapacidad'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Fecha de inicio
            ListTile(
              title: const Text('Fecha de inicio'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
              leading: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && picked != _startDate) {
                  setState(() {
                    _startDate = picked;
                    if (_endDate.isBefore(_startDate)) {
                      _endDate = _startDate.add(const Duration(days: 1));
                    }
                  });
                }
              },
            ),
            
            // Fecha de fin
            ListTile(
              title: const Text('Fecha de fin'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_endDate)),
              leading: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _endDate.isAfter(_startDate)
                      ? _endDate
                      : _startDate.add(const Duration(days: 1)),
                  firstDate: _startDate,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && picked != _endDate) {
                  setState(() {
                    _endDate = picked;
                  });
                }
              },
            ),
            
            // Horas (solo para horas extra)
            if (_selectedType == RequestType.overtime)
              TextField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Número de Horas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            
            const SizedBox(height: 16),
            
            // Motivo
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo de la solicitud',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 16),
            
            // Documentos adjuntos (solo para incapacidad)
            if (_selectedType == RequestType.disability)
              ElevatedButton.icon(
                onPressed: () {
                  // Simular selección de archivo
                  setState(() {
                    _attachmentName = 'incapacidad_medica.pdf';
                  });
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Subir Comprobante'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                ),
              ),
            
            if (_attachmentName != null && _selectedType == RequestType.disability)
              ListTile(
                leading: const Icon(Icons.file_present),
                title: Text(_attachmentName!),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _attachmentName = null;
                    });
                  },
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Botón de envío
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('ENVIAR SOLICITUD'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese el motivo de la solicitud')),
      );
      return;
    }

    if (_selectedType == RequestType.overtime && _hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese el número de horas')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      final request = Request(
        id: 'temp',
        type: _selectedType,
        status: RequestStatus.pending,
        startDate: _startDate,
        endDate: _endDate,
        hours: _selectedType == RequestType.overtime
            ? int.tryParse(_hoursController.text)
            : null,
        reason: _reasonController.text,
        attachmentUrl: _attachmentName != null ? 'example.com/$_attachmentName' : null,
        createdAt: DateTime.now(),
      );

      widget.onSubmit(request);
      Navigator.pop(context);
    });
  }
}