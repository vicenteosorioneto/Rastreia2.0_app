import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String userNameKey = 'user_name';
  static const String stolenObjectsKey = 'stolen_objects';

  // Salvar nome do usuário
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  // Ler nome do usuário
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  // Remover nome do usuário
  Future<void> removeUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
  }

  // Salvar lista de objetos roubados
  Future<void> saveStolenObjects(List<StolenObject> objects) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = objects
        .map((obj) => jsonEncode(obj.toJson()))
        .toList();
    await prefs.setStringList(stolenObjectsKey, jsonList);
  }

  // Ler lista de objetos roubados
  Future<List<StolenObject>> getStolenObjects() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(stolenObjectsKey);
    if (jsonList == null) return [];
    return jsonList
        .map((jsonStr) => StolenObject.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  // Remover todos os objetos roubados
  Future<void> removeStolenObjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(stolenObjectsKey);
  }
}

class StolenObject {
  final String name;
  final String description;
  final String date;

  StolenObject({
    required this.name,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'date': date,
  };

  factory StolenObject.fromJson(Map<String, dynamic> json) => StolenObject(
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    date: json['date'] ?? '',
  );
}
