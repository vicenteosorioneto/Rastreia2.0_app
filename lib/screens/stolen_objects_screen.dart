import 'package:flutter/material.dart';
import 'package:objeto_rastreado_app/services/local_storage_service.dart';

class StolenObjectsScreen extends StatefulWidget {
  const StolenObjectsScreen({Key? key}) : super(key: key);

  @override
  State<StolenObjectsScreen> createState() => _StolenObjectsScreenState();
}

class _StolenObjectsScreenState extends State<StolenObjectsScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<StolenObject> _objects = [];

  @override
  void initState() {
    super.initState();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    final objects = await _storageService.getStolenObjects();
    setState(() {
      _objects = objects;
    });
  }

  Future<void> _addObject() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dateController.text.isEmpty)
      return;
    final newObject = StolenObject(
      name: _nameController.text,
      description: _descriptionController.text,
      date: _dateController.text,
    );
    _objects.add(newObject);
    await _storageService.saveStolenObjects(_objects);
    _nameController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _loadObjects();
  }

  Future<void> _removeObject(int index) async {
    _objects.removeAt(index);
    await _storageService.saveStolenObjects(_objects);
    _loadObjects();
  }

  Future<void> _removeAllObjects() async {
    await _storageService.removeStolenObjects();
    _loadObjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos Roubados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _removeAllObjects,
            tooltip: 'Remover todos',
          ),
        ],
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
              onPressed: _addObject,
              child: const Text('Adicionar objeto'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lista de objetos roubados:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _objects.isEmpty
                  ? const Center(child: Text('Nenhum objeto cadastrado.'))
                  : ListView.builder(
                      itemCount: _objects.length,
                      itemBuilder: (context, index) {
                        final obj = _objects[index];
                        return Card(
                          child: ListTile(
                            title: Text(obj.name),
                            subtitle: Text(
                              'Descrição: ${obj.description}\nData: ${obj.date}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeObject(index),
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
