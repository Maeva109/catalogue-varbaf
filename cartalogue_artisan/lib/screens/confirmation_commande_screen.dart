import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/panier_service.dart';

class ConfirmationCommandeScreen extends StatefulWidget {
  const ConfirmationCommandeScreen({super.key});

  @override
  State<ConfirmationCommandeScreen> createState() => _ConfirmationCommandeScreenState();
}

class _ConfirmationCommandeScreenState extends State<ConfirmationCommandeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final panier = context.read<PanierService>();
    final total = panier.totalPrice;
    return Scaffold(
      appBar: AppBar(title: const Text('Validation de la commande')),
      body: _isConfirmed
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  const Text('Commande confirmée !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      panier.clearPanier();
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
                  const Text('Résumé de la commande', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ...panier.items.map((item) => ListTile(
                        leading: Image.network(item.produit.urlImage, width: 40, height: 40, fit: BoxFit.cover),
                        title: Text(item.produit.nom),
                        subtitle: Text('${item.quantite} × ${item.produit.prix.toStringAsFixed(0)} FCFA'),
                        trailing: Text('${(item.quantite * item.produit.prix).toStringAsFixed(0)} FCFA'),
                      )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('$total FCFA', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Vos informations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nomController,
                          decoration: const InputDecoration(labelText: 'Nom complet'),
                          validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telController,
                          decoration: const InputDecoration(labelText: 'Téléphone'),
                          validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Envoyer la commande à l'API ici
                                setState(() => _isConfirmed = true);
                              }
                            },
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
