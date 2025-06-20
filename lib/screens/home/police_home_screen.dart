import 'package:flutter/material.dart';
import 'package:objeto_rastreado_app/services/api_service.dart';

class PoliceHomeScreen extends StatefulWidget {
  const PoliceHomeScreen({Key? key}) : super(key: key);

  @override
  State<PoliceHomeScreen> createState() => _PoliceHomeScreenState();
}

class _PoliceHomeScreenState extends State<PoliceHomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _objects = [];
  List<Map<String, dynamic>> _filteredObjects = [];
  bool _loading = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    setState(() => _loading = true);
    try {
      final objects = await _apiService.fetchStolenObjects();
      setState(() {
        _objects = objects;
        _filteredObjects = objects;
      });
    } catch (e) {
      // Erro silenciado, não exibe SnackBar
    } finally {
      setState(() => _loading = false);
    }
  }

  void _filterObjects(String value) {
    setState(() {
      _search = value;
      _filteredObjects = _objects.where((obj) {
        final title = (obj['title'] ?? '').toString().toLowerCase();
        final date = (obj['date'] ?? '').toString().toLowerCase();
        return title.contains(value.toLowerCase()) ||
            date.contains(value.toLowerCase());
      }).toList();
    });
  }

  void _showObjectDetails(Map<String, dynamic> obj) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, size: 32, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        obj['title'] ?? 'Sem título',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.category_outlined,
                  'Categoria',
                  obj['category'] ?? 'Não informada',
                ),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.description_outlined,
                  'Descrição',
                  obj['body'] ?? '',
                ),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  'Localização',
                  obj['location'] ?? 'Não informada',
                ),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.info_outline,
                  'Status',
                  obj['status'] ?? 'Desconhecido',
                ),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Data',
                  obj['date'] ?? 'Não informada',
                ),
                SizedBox(height: 8),
                _buildDetailRow(
                  Icons.assignment_outlined,
                  'ID',
                  obj['id']?.toString() ?? '',
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Policial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar objeto por nome ou data',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterObjects,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Total de objetos cadastrados: ${_objects.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredObjects.isEmpty
                  ? const Center(child: Text('Nenhum objeto encontrado.'))
                  : ListView.builder(
                      itemCount: _filteredObjects.length,
                      itemBuilder: (context, index) {
                        final obj = _filteredObjects[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _showObjectDetails(obj),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Imagem do objeto (placeholder)
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Informações do objeto
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          obj['title'] ?? 'Sem título',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Categoria: ${obj['category'] ?? 'Não informada'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Localização: ${obj['location'] ?? 'Não informada'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              obj['date'] ??
                                                  'Data não informada',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status do objeto
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      obj['status'] ?? 'Roubado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
