import 'package:flutter/material.dart';
import 'package:objeto_rastreado_app/services/local_storage_service.dart';

class LocalStorageExample extends StatefulWidget {
  @override
  _LocalStorageExampleState createState() => _LocalStorageExampleState();
}

class _LocalStorageExampleState extends State<LocalStorageExample> {
  final LocalStorageService _storageService = LocalStorageService();
  final TextEditingController _controller = TextEditingController();
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _storageService.getUserName();
    setState(() {
      _savedName = name;
    });
  }

  Future<void> _saveUserName() async {
    await _storageService.saveUserName(_controller.text);
    _loadUserName();
  }

  Future<void> _removeUserName() async {
    await _storageService.removeUserName();
    _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemplo SharedPreferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Digite seu nome'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUserName,
              child: Text('Salvar nome'),
            ),
            ElevatedButton(
              onPressed: _removeUserName,
              child: Text('Remover nome'),
            ),
            SizedBox(height: 32),
            Text(
              _savedName != null
                  ? 'Nome salvo: [1m$_savedName[0m'
                  : 'Nenhum nome salvo',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
