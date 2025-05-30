import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/panier_item.dart';

class PanierService extends ChangeNotifier {
  List<PanierItem> _items = [];

  List<PanierItem> get items => _items;

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantite);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.produit.prix * item.quantite);

  PanierService() {
    _loadPanier();
  }

  void addToPanier(PanierItem item) {
    final index = _items.indexWhere((e) => e.produit.id == item.produit.id);
    if (index >= 0) {
      _items[index].quantite += item.quantite;
    } else {
      _items.add(item);
    }
    _savePanier();
    notifyListeners();
  }

  void removeFromPanier(int produitId) {
    _items.removeWhere((e) => e.produit.id == produitId);
    _savePanier();
    notifyListeners();
  }

  void changeQuantite(int produitId, int delta) {
    final index = _items.indexWhere((e) => e.produit.id == produitId);
    if (index >= 0) {
      _items[index].quantite += delta;
      if (_items[index].quantite <= 0) {
        _items.removeAt(index);
      }
      _savePanier();
      notifyListeners();
    }
  }

  void clearPanier() {
    _items.clear();
    _savePanier();
    notifyListeners();
  }

  Future<void> _savePanier() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('panier', data);
  }

  Future<void> _loadPanier() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('panier') ?? [];
    _items = data.map((e) => PanierItem.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }
}
