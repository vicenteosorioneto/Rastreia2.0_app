import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String objectsEndpoint = '/posts'; // Usando posts como exemplo

  // Buscar todos os objetos roubados (GET)
  Future<List<Map<String, dynamic>>> fetchStolenObjects() async {
    final response = await http.get(Uri.parse('$baseUrl$objectsEndpoint'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar objetos');
    }
  }

  // Adicionar novo objeto roubado (POST)
  Future<Map<String, dynamic>> addStolenObject({
    required String name,
    required String description,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$objectsEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': name, 'body': description, 'date': date}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao adicionar objeto');
    }
  }

  // Remover objeto roubado (DELETE)
  Future<void> deleteStolenObject(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$objectsEndpoint/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao remover objeto');
    }
  }
}
