import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categorie.dart';

class CategorieService {
  static const String baseUrl = 'http://localhost:8000/api/categories/';

  Future<List<Categorie>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Categorie.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des catégories');
    }
  }

  Future<Categorie> addCategorie(String nom) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nom': nom}),
    );
    if (response.statusCode == 201) {
      return Categorie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout');
    }
  }

  Future<void> updateCategorie(int id, String nom) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nom': nom}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }

  Future<void> deleteCategorie(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression');
    }
  }
}
