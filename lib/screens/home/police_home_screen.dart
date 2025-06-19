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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar objetos: $e')));
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
      builder: (context) => AlertDialog(
        title: Text(obj['title'] ?? 'Sem título'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${obj['body'] ?? ''}'),
            const SizedBox(height: 8),
            Text('Data: ${obj['date'] ?? 'Não informada'}'),
            const SizedBox(height: 8),
            Text('ID: ${obj['id'] ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
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
                          child: ListTile(
                            leading: const Icon(Icons.security),
                            title: Text(obj['title'] ?? ''),
                            subtitle: Text(
                              'Data: ${obj['date'] ?? 'Não informada'}',
                            ),
                            onTap: () => _showObjectDetails(obj),
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
