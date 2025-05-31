import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../services/api_service.dart';
import '../widgets/produit_card.dart';
import 'package:provider/provider.dart';
import '../models/panier_item.dart';
import '../services/panier_service.dart';
import '../widgets/panier_icon.dart';
import '../widgets/similar_products_widget.dart';
import 'panier_screen.dart';

class ProduitDetailScreen extends StatefulWidget {
  final Produit produit;

  const ProduitDetailScreen({
    super.key,
    required this.produit,
  });

  @override
  State<ProduitDetailScreen> createState() => _ProduitDetailScreenState();
}

class _ProduitDetailScreenState extends State<ProduitDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Produit>> _produitsSimilairesFuture;

  @override
  void initState() {
    super.initState();
    _chargerProduitsSimilaires();
  }

  Future<void> _chargerProduitsSimilaires() async {
    try {
      final produits = await _apiService.getProduits();
      final similaires = produits
          .where((p) {
            if (p.id == widget.produit.id) return false;

            // Même catégorie ou prix similaire (±20%)
            final memeCategorie = p.categorie.id == widget.produit.categorie.id;
            final prixSimilaire = (p.prix - widget.produit.prix).abs() <=
                widget.produit.prix * 0.2;

            return memeCategorie || prixSimilaire;
          })
          .take(3)
          .toList();

      setState(() {
        _produitsSimilairesFuture = Future.value(similaires);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors du chargement des produits similaires : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _produitsSimilairesFuture = Future.value([]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produit.nom),
        actions: [
          // Cart icon in AppBar (Optional, already removed in CatalogueScreen)
          // If you want it here, uncomment and add the badge Consumer as in main.dart BottomNavBar
          // IconButton(
          //   icon: const Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     // Add product to cart and show snackbar
          //     context.read<PanierService>().ajouterProduit(widget.produit);
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Produit ajouté au panier'),
          //         duration: Duration(seconds: 2),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.produit.urlImage,
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
                      Expanded(
                        child: Text(
                          widget.produit.nom,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.produit.prix.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.produit.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Catégorie: ${widget.produit.categorie.nom}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.inventory, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Stock: ${widget.produit.stock}',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.produit.stock > 0
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.produit.stock > 0
                          ? () {
                              context.read<PanierService>().addToPanier(
                                  PanierItem(produit: widget.produit));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Produit ajouté au panier')),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produits similaires',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: FutureBuilder<List<Produit>>(
                      future: _produitsSimilairesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Aucun produit similaire trouvé'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final produit = snapshot.data![index];
                            return SizedBox(
                              width: 180,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: ProduitCard(
                                  produit: produit,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProduitDetailScreen(
                                          produit: produit,
                                        ),
                                      ),
                                    );
                                  },
                                  onAddToCart: () {
                                    context.read<PanierService>().addToPanier(
                                        PanierItem(produit: produit));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${produit.nom} ajouté au panier'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  onFavorite: null,
                                  onEdit: null,
                                  onDelete: null,
                                ),
                              ),
                            );
                          },
                        );
                      },
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
