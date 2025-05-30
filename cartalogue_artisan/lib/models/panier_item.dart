import 'produit.dart';

class PanierItem {
  final Produit produit;
  int quantite;

  PanierItem({required this.produit, this.quantite = 1});

  Map<String, dynamic> toJson() => {
        'produit': produit.toJson(),
        'quantite': quantite,
      };

  factory PanierItem.fromJson(Map<String, dynamic> json) => PanierItem(
        produit: Produit.fromJson(json['produit']),
        quantite: json['quantite'],
      );
}
