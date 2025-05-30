import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/produit.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';
import 'produit_detail_screen.dart';
import '../widgets/produit_card.dart';
import '../widgets/panier_icon.dart';
import 'panier_screen.dart';
import 'edit_produit_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Produit>> _produitsFuture;
  List<Categorie> _categories = [];
  String selectedCategorie = 'Filtrer par catégorie';
  final List<String> _carouselImages = [
    'https://images.pexels.com/photos/8628442/pexels-photo-8628442.jpeg',
    'https://images.pexels.com/photos/5028727/pexels-photo-5028727.jpeg',
    'https://images.pexels.com/photos/3307279/pexels-photo-3307279.jpeg',
    'https://images.pexels.com/photos/31576064/pexels-photo-31576064/free-photo-of-colorful-moroccan-baskets-and-textiles-in-marrakech-market.jpeg',
  ];
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndProduits();
  }

  // Charge les catégories et initialise la liste des produits
  Future<void> _loadCategoriesAndProduits() async {
    final cats = await _apiService.getCategories();
    setState(() {
      _categories = cats;
      selectedCategorie = 'Toutes';
      _produitsFuture = _apiService.getProduits();
    });
  }

  // Recharge les produits selon la catégorie sélectionnée
  void _reloadProduits() {
    setState(() {
      if (selectedCategorie == 'Toutes') {
        _produitsFuture = _apiService.getProduits();
      } else {
        final cat = _categories.firstWhere((c) => c.nom == selectedCategorie,
            orElse: () => _categories.first);
        _produitsFuture = _apiService.getProduitsByCategorie(cat.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E7D8),
      appBar: AppBar(
        title: const Text('Catalogue Artisanal'),
        backgroundColor: const Color(0xFFB85C38),
        actions: [
          PanierIcon(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PanierScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'Vue liste' : 'Vue grille',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadProduits,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFB85C38),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un produit'),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/ajout-produit');
          if (result == true) _reloadProduits();
        },
      ),
      body: Column(
        children: [
          // Description du village artisanal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color(0xFFE0A96D).withOpacity(0.2),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Bienvenue au Village Artisanal !\nDécouvrez nos créations uniques, faites main par nos artisans locaux.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Menu de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TypeAheadField<Produit>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];
                final produits = await _apiService.getProduits();
                return produits
                    .where((p) =>
                        p.nom.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, Produit suggestion) {
                return ListTile(
                  leading: Image.network(suggestion.urlImage,
                      width: 40, height: 40, fit: BoxFit.cover),
                  title: Text(suggestion.nom),
                  subtitle: Text('${suggestion.prix.toStringAsFixed(0)} FCFA'),
                );
              },
              onSuggestionSelected: (Produit suggestion) {
                _showDetail(suggestion);
              },
              noItemsFoundBuilder: (context) => const ListTile(
                title: Text('Aucun résultat'),
              ),
            ),
          ),
          // Carrousel d'images artisanales
          CarouselSlider(
            options: CarouselOptions(
              height: 140.0,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
            ),
            items: _carouselImages
                .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(url,
                          fit: BoxFit.cover, width: double.infinity),
                    ))
                .toList(),
          ),
          // Menu déroulant des catégories dynamique
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategorie,
              hint: const Text('Filtrer par catégorie'),
              items: [
                const DropdownMenuItem(
                  value: 'Toutes',
                  child: Text('Toutes'),
                ),
                ..._categories.map((cat) => DropdownMenuItem(
                      value: cat.nom,
                      child: Text(cat.nom),
                    ))
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategorie = value;
                    _reloadProduits();
                  });
                }
              },
            ),
          ),
          // Grille de produits
          Expanded(
            child: FutureBuilder<List<Produit>>(
              future: _produitsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: \\${snapshot.error}'));
                }
                final produits = snapshot.data ?? [];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
                    if (_isGridView) {
                      return MasonryGridView.count(
                        crossAxisCount: crossAxisCount,
                        itemCount: produits.length,
                        itemBuilder: (context, index) {
                          final produit = produits[index];
                          final isNouveau = produit.createdAt.isAfter(
                              DateTime.now().subtract(const Duration(days: 7)));
                          return ProduitCard(
                            produit: produit,
                            isNouveau: isNouveau,
                            onTap: () => _showDetail(produit),
                            onFavorite: () => _toggleFavorite(produit),
                            onEdit: () => _editProduit(produit),
                            onDelete: () => _confirmDeleteProduit(produit),
                          );
                        },
                      );
                    } else {
                      // Vue liste
                      return ListView.builder(
                        itemCount: produits.length,
                        itemBuilder: (context, index) {
                          final produit = produits[index];
                          final isNouveau = produit.createdAt.isAfter(
                              DateTime.now().subtract(const Duration(days: 7)));
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: ListTile(
                              leading: Image.network(produit.urlImage,
                                  width: 60, height: 60, fit: BoxFit.cover),
                              title: Text(produit.nom,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${produit.prix.toStringAsFixed(0)} FCFA',
                                      style:
                                          const TextStyle(color: Colors.green)),
                                  Text('Stock: ${produit.stock}',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text(produit.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFFB85C38)),
                                    tooltip: 'Modifier',
                                    onPressed: () => _editProduit(produit),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'Supprimer',
                                    onPressed: () =>
                                        _confirmDeleteProduit(produit),
                                  ),
                                ],
                              ),
                              onTap: () => _showDetail(produit),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(Produit produit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProduitDetailScreen(produit: produit),
      ),
    );
  }

  void _toggleFavorite(Produit produit) {
    // À implémenter : gestion favoris côté API ou local
  }

  void _editProduit(Produit produit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProduitScreen(
          produit: produit,
          categories: _categories,
        ),
      ),
    );
    if (result == true) _reloadProduits();
  }

  void _confirmDeleteProduit(Produit produit) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce produit ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _apiService.deleteProduit(produit.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit supprimé')),
        );
        _reloadProduits();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }
  }
}
