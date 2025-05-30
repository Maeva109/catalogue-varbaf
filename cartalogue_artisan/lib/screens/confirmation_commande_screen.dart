import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/panier_service.dart';
import '../services/api_service.dart';

class ConfirmationCommandeScreen extends StatefulWidget {
  const ConfirmationCommandeScreen({super.key});

  @override
  State<ConfirmationCommandeScreen> createState() =>
      _ConfirmationCommandeScreenState();
}

class _ConfirmationCommandeScreenState
    extends State<ConfirmationCommandeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  final _apiService = ApiService();
  bool _isConfirmed = false;
  bool _isLoading = false;

  Future<void> _processCommande() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final panier = context.read<PanierService>();

      // Mettre à jour le stock pour chaque produit
      for (final item in panier.items) {
        final newStock = item.produit.stock - item.quantite;
        if (newStock < 0) {
          throw Exception('Stock insuffisant pour ${item.produit.nom}');
        }
        await _apiService.updateStock(item.produit.id, newStock);
      }

      // TODO: Envoyer la commande à l'API ici
      // Pour l'instant, on simule juste la confirmation

      // Vider le panier
      panier.clearPanier();

      if (mounted) {
        setState(() => _isConfirmed = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Commande validée avec succès. Votre panier a été vidé.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la commande : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final panier = context.read<PanierService>();
    final total = panier.totalPrice;
    return Scaffold(
      appBar: AppBar(title: const Text('Validation de la commande')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isConfirmed
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 80),
                      const SizedBox(height: 16),
                      const Text('Commande confirmée !',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('Retour à l\'accueil'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Résumé de la commande',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      ...panier.items.map((item) => ListTile(
                            leading: Image.network(item.produit.urlImage,
                                width: 40, height: 40, fit: BoxFit.cover),
                            title: Text(item.produit.nom),
                            subtitle: Text(
                                '${item.quantite} × ${item.produit.prix.toStringAsFixed(0)} FCFA'),
                            trailing: Text(
                                '${(item.quantite * item.produit.prix).toStringAsFixed(0)} FCFA'),
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('$total FCFA',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Vos informations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomController,
                              decoration: const InputDecoration(
                                  labelText: 'Nom complet'),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Champ requis'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Champ requis'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _telController,
                              decoration:
                                  const InputDecoration(labelText: 'Téléphone'),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Champ requis'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _processCommande,
                                child: const Text('Confirmer la commande'),
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
