import 'categorie.dart';

class Produit {
  final int id;
  final String nom;
  final String description;
  final double prix;
  final String urlImage;
  final int stock;
  final bool isFavorite;
  final Categorie categorie;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Produit({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.urlImage,
    required this.stock,
    required this.isFavorite,
    required this.categorie,
    this.createdAt,
    this.updatedAt,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      prix: json['prix'].toDouble(),
      urlImage: json['url_image'],
      stock: json['stock'],
      isFavorite: json['is_favorite'],
      categorie: json['categorie'] != null
          ? Categorie.fromJson(json['categorie'])
          : Categorie(id: 0, nom: 'Inconnue'),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
      'url_image': urlImage,
      'stock': stock,
      'is_favorite': isFavorite,
      'categorie_id': categorie.id,
    };
  }
}
