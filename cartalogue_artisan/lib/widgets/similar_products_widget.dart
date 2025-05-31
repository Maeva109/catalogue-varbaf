import 'package:flutter/material.dart';
import '../models/produit.dart';

class SimilarProductsWidget extends StatelessWidget {
  final Produit currentProduit;
  final List<Produit> allProducts; // Mock data for now

  const SimilarProductsWidget({
    super.key,
    required this.currentProduit,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    // Filter similar products
    final similarProducts = allProducts
        .where((produit) {
          // Exclude the current product
          if (produit.id == currentProduit.id) {
            return false;
          }
          // Check for same category
          if (produit.categorie.id == currentProduit.categorie.id) {
            return true;
          }
          // Check for similar price (within 20%)
          final priceDiff = (produit.prix - currentProduit.prix).abs();
          final priceThreshold = currentProduit.prix * 0.20;
          if (priceDiff <= priceThreshold) {
            return true;
          }
          return false;
        })
        .take(3)
        .toList(); // Take up to 3 similar products

    if (similarProducts.isEmpty) {
      return const SizedBox.shrink(); // Hide if no similar products found
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produits similaires',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                final produit = similarProducts[index];
                return SizedBox(
                  width: 150, // Adjust width as needed
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            produit.urlImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produit.nom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${produit.prix.toStringAsFixed(0)} FCFA',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
