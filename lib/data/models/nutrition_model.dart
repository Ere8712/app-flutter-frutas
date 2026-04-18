class NutritionModel {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  NutritionModel({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  // Factory para convertir el JSON de Fruityvice a nuestro objeto Dart
  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      // Se parsea a double para evitar errores si la API manda un int (ej: 0 en lugar de 0.0)
      calories: (json['calories'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      carbohydrates: (json['carbohydrates'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
    );
  }
}