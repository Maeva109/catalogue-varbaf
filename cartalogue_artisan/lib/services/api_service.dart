import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produit.dart';
import '../models/categorie.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  // Produits
  Future<List<Produit>> getProduits() async {
    final response = await http.get(Uri.parse('$baseUrl/produits/'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load produits');
    }
  }

  Future<Produit> getProduit(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/produits/$id/'));
    if (response.statusCode == 200) {
      return Produit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load produit');
    }
  }

  Future<Produit> createProduit(Produit produit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produits/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produit.toJson()),
    );
    if (response.statusCode == 201) {
      return Produit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create produit');
    }
  }

  Future<Produit> updateProduit(int id, Produit produit) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produits/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produit.toJson()),
    );
    if (response.statusCode == 200) {
      return Produit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update produit');
    }
  }

  Future<void> updateStock(int produitId, int newStock) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/produits/$produitId/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'stock': newStock}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update stock');
    }
  }

  Future<void> deleteProduit(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produits/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete produit');
    }
  }

  // Catégories
  Future<List<Categorie>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Categorie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Categorie> createCategorie(Categorie categorie) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categorie.toJson()),
    );
    if (response.statusCode == 201) {
      return Categorie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create categorie');
    }
  }

  Future<List<Produit>> getProduitsByCategorie(int categorieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/produits/?categorie_id=$categorieId'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load produits by categorie');
    }
  }
}
