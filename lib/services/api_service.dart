import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';
import 'dart:developer';

class ApiService {
  final LocalStorageService _localStorage = LocalStorageService();

  List<Map<String, dynamic>> get _fakeObjects => [
    {
      'title': 'iPhone 13 Pro',
      'body': 'Celular roubado na Av. Paulista, próximo ao MASP.',
      'date': '25/07/2024',
      'category': 'Eletrônicos',
      'location': 'São Paulo, SP',
      'status': 'Roubado',
      'id': 1001,
    },
    {
      'title': 'Honda Civic 2022',
      'body': 'Veículo furtado na Rua Augusta. Placa RGH-1234.',
      'date': '24/07/2024',
      'category': 'Veículos',
      'location': 'São Paulo, SP',
      'status': 'Furtado',
      'id': 1002,
    },
    {
      'title': 'Notebook Dell G15',
      'body': 'Levado de dentro de uma cafeteria na Faria Lima.',
      'date': '22/07/2024',
      'category': 'Eletrônicos',
      'location': 'São Paulo, SP',
      'status': 'Roubado',
      'id': 1003,
    },
  ];

  // Buscar todos os objetos roubados (GET)
  Future<List<Map<String, dynamic>>> fetchStolenObjects() async {
    final objects = await _localStorage.getStolenObjects();
    log('fetchStolenObjects: ${objects.length} objetos encontrados');
    // Sempre retorna os fakes + reais
    final realObjects = objects
        .map(
          (obj) => {
            'title': obj.name,
            'body': obj.description,
            'date': obj.date,
            'category': '',
            'location': '',
            'status': 'Roubado',
            'id': obj.hashCode,
          },
        )
        .toList();
    return [..._fakeObjects, ...realObjects];
  }

  // Adicionar novo objeto roubado (POST)
  Future<Map<String, dynamic>> addStolenObject({
    required String name,
    required String description,
    required String date,
  }) async {
    final objects = await _localStorage.getStolenObjects();
    final newObj = StolenObject(
      name: name,
      description: description,
      date: date,
    );
    objects.add(newObj);
    await _localStorage.saveStolenObjects(objects);
    log('addStolenObject: objeto salvo (${newObj.toJson()})');
    return {
      'title': name,
      'body': description,
      'date': date,
      'category': '',
      'location': '',
      'status': 'Roubado',
      'id': newObj.hashCode,
    };
  }

  // Remover objeto roubado (DELETE)
  Future<void> deleteStolenObject(int id) async {
    final objects = await _localStorage.getStolenObjects();
    objects.removeWhere((obj) => obj.hashCode == id);
    await _localStorage.saveStolenObjects(objects);
    log('deleteStolenObject: objeto removido id=$id');
  }
}
