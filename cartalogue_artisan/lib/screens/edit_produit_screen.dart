import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';

class EditProduitScreen extends StatefulWidget {
  final Produit produit;
  final List<Categorie> categories;
  const EditProduitScreen(
      {super.key, required this.produit, required this.categories});

  @override
  State<EditProduitScreen> createState() => _EditProduitScreenState();
}

class _EditProduitScreenState extends State<EditProduitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixController;
  late TextEditingController _urlImageController;
  late TextEditingController _stockController;
  Categorie? _selectedCategorie;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.produit.nom);
    _descriptionController =
        TextEditingController(text: widget.produit.description);
    _prixController =
        TextEditingController(text: widget.produit.prix.toString());
    _urlImageController = TextEditingController(text: widget.produit.urlImage);
    _stockController =
        TextEditingController(text: widget.produit.stock.toString());
    _selectedCategorie = widget.categories
        .firstWhere((c) => c.id == widget.produit.categorie.id);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _urlImageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategorie == null)
      return;
    setState(() => _isLoading = true);
    try {
      final updatedProduit = Produit(
        id: widget.produit.id,
        nom: _nomController.text,
        description: _descriptionController.text,
        prix: double.parse(_prixController.text),
        urlImage: _urlImageController.text,
        stock: int.parse(_stockController.text),
        isFavorite: widget.produit.isFavorite,
        categorie: _selectedCategorie!,
        createdAt: widget.produit.createdAt,
        updatedAt: DateTime.now(),
      );
      await ApiService().updateProduit(widget.produit.id, updatedProduit);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit modifié avec succès')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la modification : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le produit')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration:
                          const InputDecoration(labelText: 'Nom du produit'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _prixController,
                      decoration: const InputDecoration(labelText: 'Prix'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _urlImageController,
                      decoration:
                          const InputDecoration(labelText: 'URL de l\'image'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Categorie>(
                      value: _selectedCategorie,
                      decoration: const InputDecoration(labelText: 'Catégorie'),
                      items: widget.categories.map((categorie) {
                        return DropdownMenuItem(
                          value: categorie,
                          child: Text(categorie.nom),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategorie = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Sélectionnez une catégorie' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Enregistrer les modifications'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
