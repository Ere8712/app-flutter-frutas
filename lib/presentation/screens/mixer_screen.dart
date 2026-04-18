import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cocktail_model.dart';
import '../../core/fruit_translations.dart';
import '../providers/fruit_provider.dart';

class MixerScreen extends StatelessWidget {
  const MixerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FruitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creador de Cócteles 🍹'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => provider.clearCocktail(),
            tooltip: 'Limpiar selección',
          )
        ],
      ),
      body: Column(
        children: [
          // Selector de Tamaño
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<BowlSize>(
              segments: const [
                ButtonSegment(
                  value: BowlSize.small,
                  label: Text('Chico (250g)'),
                  icon: Icon(Icons.rice_bowl),
                ),
                ButtonSegment(
                  value: BowlSize.large,
                  label: Text('Grande (500g)'),
                  icon: Icon(Icons.soup_kitchen),
                ),
              ],
              selected: {provider.currentBowlSize},
              onSelectionChanged: (Set<BowlSize> newSelection) {
                provider.setBowlSize(newSelection.first);
              },
            ),
          ),
          
          const Divider(),
          
          // Lista Seleccionable de Frutas
          Expanded(
            child: ListView.builder(
              itemCount: provider.fruits.length,
              itemBuilder: (context, index) {
                final fruit = provider.fruits[index];
                final isSelected = provider.selectedFruits.contains(fruit);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.orange : Colors.grey[200],
                    child: Text(translateFruit(fruit.name)[0]),
                  ),
                  title: Text(translateFruit(fruit.name), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${fruit.nutritions.calories} kcal / 100g'),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.orange) 
                      : const Icon(Icons.circle_outlined),
                  onTap: () => provider.toggleFruitSelection(fruit),
                );
              },
            ),
          ),
        ],
      ),
      // Botón flotante para ver resultados
      floatingActionButton: provider.selectedFruits.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showResultsBottomSheet(context, provider),
              icon: const Icon(Icons.calculate),
              label: Text('Analizar ${provider.selectedFruits.length} frutas'),
            )
          : null,
    );
  }

  // --- PASO 3: HOJA DE RESULTADOS (BottomSheet) ---
  void _showResultsBottomSheet(BuildContext context, FruitProvider provider) {
    final cocktail = provider.currentCocktail;
    final totalNutrition = cocktail.totalNutrition;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Resumen Nutricional',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Plato de ${cocktail.totalWeight}g (${cocktail.portionPerFruit.toStringAsFixed(1)}g por fruta)',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Resultados Totales
              _buildResultRow('🔥 Calorías Totales:', '${totalNutrition.calories.toStringAsFixed(1)} kcal', Colors.orange),
              _buildResultRow('🍬 Azúcar Total:', '${totalNutrition.sugar.toStringAsFixed(1)} g', Colors.purple),
              _buildResultRow('🍞 Carbohidratos:', '${totalNutrition.carbohydrates.toStringAsFixed(1)} g', Colors.blue),
              _buildResultRow('💪 Proteína:', '${totalNutrition.protein.toStringAsFixed(1)} g', Colors.green),
              _buildResultRow('🥑 Grasa:', '${totalNutrition.fat.toStringAsFixed(1)} g', Colors.red),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}