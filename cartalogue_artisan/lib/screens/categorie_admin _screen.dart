import 'package:flutter/material.dart';
import '../models/categorie.dart';
import '../services/categorie_service.dart';

class CategorieAdminScreen extends StatefulWidget {
  const CategorieAdminScreen({super.key});

  @override
  State<CategorieAdminScreen> createState() => _CategorieAdminScreenState();
}

class _CategorieAdminScreenState extends State<CategorieAdminScreen> {
  List<Categorie> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      _categories = await CategorieService().getCategories();
      setState(() { _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  void _showCategorieDialog({Categorie? categorie}) {
    final controller = TextEditingController(text: categorie?.nom ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(categorie == null ? 'Nouvelle catégorie' : 'Modifier la catégorie'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nom'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              try {
                if (categorie == null) {
                  await CategorieService().addCategorie(controller.text);
                } else {
                  await CategorieService().updateCategorie(categorie.id, controller.text);
                }
                Navigator.pop(context);
                _loadCategories();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Catégorie enregistrée !')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : $e')),
                );
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _deleteCategorie(Categorie categorie) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la catégorie ?'),
        content: Text('Voulez-vous vraiment supprimer "${categorie.nom}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await CategorieService().deleteCategorie(categorie.id);
        _loadCategories();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catégorie supprimée !')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des catégories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategorieDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Nouvelle catégorie',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return ListTile(
                      leading: const Icon(Icons.category),
                      title: Text(cat.nom),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showCategorieDialog(categorie: cat),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategorie(cat),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}