import 'fruit_model.dart';
import 'nutrition_model.dart';

/// Define los tamaños de plato disponibles y su capacidad en gramos.
enum BowlSize {
  small(250.0),
  large(500.0);

  final double grams;
  const BowlSize(this.grams);
}

class CocktailModel {
  final String id;
  final List<FruitModel> selectedFruits;
  final BowlSize size;

  CocktailModel({
    required this.id,
    required this.selectedFruits,
    required this.size,
  });

  /// Peso total del cóctel según el tamaño del plato seleccionado.
  double get totalWeight => size.grams;

  /// Gramos asignados a cada fruta de forma equitativa.
  /// Si no hay frutas, la porción es 0.
  double get portionPerFruit {
    if (selectedFruits.isEmpty) return 0.0;
    return totalWeight / selectedFruits.length;
  }

  /// Calcula la información nutricional total sumando el aporte real de cada fruta.
  NutritionModel get totalNutrition {
    double totalCalories = 0;
    double totalFat = 0;
    double totalSugar = 0;
    double totalCarbs = 0;
    double totalProtein = 0;

    final double portion = portionPerFruit;

    for (var fruit in selectedFruits) {
      // La API entrega valores por cada 100g. 
      // Calculamos el factor: (gramos por fruta / 100)
      final double factor = portion / 100.0;

      totalCalories += fruit.nutritions.calories * factor;
      totalFat += fruit.nutritions.fat * factor;
      totalSugar += fruit.nutritions.sugar * factor;
      totalCarbs += fruit.nutritions.carbohydrates * factor;
      totalProtein += fruit.nutritions.protein * factor;
    }

    return NutritionModel(
      calories: totalCalories,
      fat: totalFat,
      sugar: totalSugar,
      carbohydrates: totalCarbs,
      protein: totalProtein,
    );
  }
}