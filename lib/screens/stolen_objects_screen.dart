import 'package:flutter/material.dart';
import 'package:objeto_rastreado_app/services/api_service.dart';

class StolenObjectsScreen extends StatefulWidget {
  const StolenObjectsScreen({Key? key}) : super(key: key);

  @override
  State<StolenObjectsScreen> createState() => _StolenObjectsScreenState();
}

class _StolenObjectsScreenState extends State<StolenObjectsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<Map<String, dynamic>> _objects = [];
  bool _loading = false;

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
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar objetos: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addObject() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dateController.text.isEmpty)
      return;
    setState(() => _loading = true);
    try {
      await _apiService.addStolenObject(
        name: _nameController.text,
        description: _descriptionController.text,
        date: _dateController.text,
      );
      _nameController.clear();
      _descriptionController.clear();
      _dateController.clear();
      await _loadObjects();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar objeto: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _removeObject(int id) async {
    setState(() => _loading = true);
    try {
      await _apiService.deleteStolenObject(id);
      await _loadObjects();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover objeto: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
        title: const Text('Objetos Roubados (API)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do objeto'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Data do roubo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _addObject,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Adicionar objeto'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lista de objetos roubados:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _objects.isEmpty
                  ? const Center(child: Text('Nenhum objeto cadastrado.'))
                  : ListView.builder(
                      itemCount: _objects.length,
                      itemBuilder: (context, index) {
                        final obj = _objects[index];
                        return Card(
                          child: ListTile(
                            title: Text(obj['title'] ?? ''),
                            subtitle: Text(
                              'Descrição: ${obj['body'] ?? ''}\nData: ${obj['date'] ?? ''}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeObject(obj['id'] ?? 0),
                              tooltip: 'Remover',
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
