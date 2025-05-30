import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/panier_service.dart';
import 'confirmation_commande_screen.dart';

class PanierScreen extends StatelessWidget {
  const PanierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panier = context.watch<PanierService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: panier.items.length,
              itemBuilder: (context, i) {
                final item = panier.items[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.network(item.produit.urlImage,
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.produit.nom),
                    subtitle:
                        Text('${item.produit.prix.toStringAsFixed(0)} FCFA'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () =>
                              panier.changeQuantite(item.produit.id, -1),
                        ),
                        Text('${item.quantite}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              panier.changeQuantite(item.produit.id, 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              panier.removeFromPanier(item.produit.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total :',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${panier.totalPrice.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: panier.items.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const ConfirmationCommandeScreen()),
                            );
                          },
                    child: const Text('Passer commande'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
