import 'package:flutter/material.dart';
import 'screens/catalogue_screen.dart';
import 'screens/ajout_produit_screen.dart';
import 'screens/categorie_admin _screen.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'services/panier_service.dart';
import '../widgets/panier_icon.dart';
import '../models/panier_item.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PanierService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalogue Artisanal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: const Color(0xFFB85C38), // ocre
          secondary: const Color(0xFFE0A96D), // beige/orange
          background: const Color(0xFFF6E7D8), // fond clair
          brightness: Brightness.light,
        ),
        fontFamily: 'Merriweather', // ou une police plus chaleureuse
        scaffoldBackgroundColor: const Color(0xFFF6E7D8),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
      routes: {
        '/ajout-produit': (context) => const AjoutProduitScreen(),
        '/admin-categories': (context) => const CategorieAdminScreen(),
      },
    );
  }
}
