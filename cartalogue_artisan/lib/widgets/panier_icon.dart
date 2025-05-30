import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/panier_service.dart';

class PanierIcon extends StatelessWidget {
  final VoidCallback onTap;
  const PanierIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<PanierService>().totalCount;
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
      ],
    );
  }
}
