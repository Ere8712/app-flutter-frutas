import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fruit_provider.dart';
import '../widgets/fruit_card.dart';
import '../../core/fruit_translations.dart';
import 'detail_screen.dart';
import 'mixer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar fruta...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.blender),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MixerScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<FruitProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(provider.errorMessage,
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final fruits = _searchQuery.isEmpty
              ? provider.fruits
              : provider.fruits
                  .where((f) =>
                      f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      translateFruit(f.name).toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      f.family.toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

          if (fruits.isEmpty) {
            return const Center(child: Text('No se encontraron frutas.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: fruits.length,
            itemBuilder: (context, index) {
              final fruit = fruits[index];
              return FruitCard(
                fruit: fruit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FruitDetailScreen(fruit: fruit),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
