import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/fruit_model.dart';
import '../../core/fruit_translations.dart';

class FruitDetailScreen extends StatelessWidget {
  final FruitModel fruit;

  const FruitDetailScreen({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Cabecera animada con la imagen
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                translateFruit(fruit.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: _buildHeaderImage(),
            ),
          ),
          
          // Contenido desplazable
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Taxonomía'),
                  _buildTaxonomyCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Información Nutricional (por 100g)'),
                  _buildNutritionGrid(),
                  const SizedBox(height: 40), // Espacio al final
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeaderImage() {
    if (fruit.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: fruit.imageUrl!,
        fit: BoxFit.cover,
        // Un gradiente oscuro en la parte inferior para que el título en blanco siempre se lea
        colorBlendMode: BlendMode.darken,
        color: Colors.black26, 
      );
    }
    return Container(
      color: Colors.orange[200],
      child: const Icon(Icons.image_not_supported, size: 80, color: Colors.white),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTaxonomyCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTaxonomyRow('Familia', fruit.family),
            const Divider(),
            _buildTaxonomyRow('Orden', fruit.order),
            const Divider(),
            _buildTaxonomyRow('Género', fruit.genus),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxonomyRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildNutritionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // Importante cuando está dentro de un ScrollView
      physics: const NeverScrollableScrollPhysics(), // Evita scroll doble
      childAspectRatio: 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildNutritionTile('Calorías', '${fruit.nutritions.calories} kcal', Colors.orange),
        _buildNutritionTile('Azúcar', '${fruit.nutritions.sugar} g', Colors.purple),
        _buildNutritionTile('Grasa', '${fruit.nutritions.fat} g', Colors.red),
        _buildNutritionTile('Carbohidratos', '${fruit.nutritions.carbohydrates} g', Colors.blue),
        _buildNutritionTile('Proteína', '${fruit.nutritions.protein} g', Colors.green),
      ],
    );
  }

  Widget _buildNutritionTile(String label, String value, MaterialColor color) {
    return Container(
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: color.shade800)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color.shade900)),
        ],
      ),
    );
  }
}