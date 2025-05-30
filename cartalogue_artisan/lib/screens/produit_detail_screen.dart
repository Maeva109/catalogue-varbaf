import 'package:flutter/material.dart';
import '../models/produit.dart';
import 'package:provider/provider.dart';
import '../models/panier_item.dart';
import '../services/panier_service.dart';
import '../widgets/panier_icon.dart';
import 'panier_screen.dart';

class ProduitDetailScreen extends StatelessWidget {
  final Produit produit;

  const ProduitDetailScreen({
    super.key,
    required this.produit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produit.nom),
        actions: [
          PanierIcon(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PanierScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              produit.urlImage,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 50),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${produit.prix.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          produit.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: produit.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          // TODO: Implémenter la fonctionnalité de favoris
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produit.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category),
                      const SizedBox(width: 8),
                      Text(
                        'Catégorie: ${produit.categorie.nom}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.inventory),
                      const SizedBox(width: 8),
                      Text(
                        'Stock: ${produit.stock}',
                        style: TextStyle(
                          fontSize: 16,
                          color: produit.stock > 0 ? Colors.black : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<PanierService>()
                            .addToPanier(PanierItem(produit: produit));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Produit ajouté au panier')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
