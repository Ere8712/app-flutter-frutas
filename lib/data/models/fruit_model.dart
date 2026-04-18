import 'nutrition_model.dart';

class FruitModel {
  final int id;
  final String name;
  final String family;
  final String order;
  final String genus;
  final NutritionModel nutritions;
  
  // imageUrl no es 'final' porque lo actualizaremos después de hacer 
  // la segunda petición a la API de imágenes.
  String? imageUrl; 

  FruitModel({
    required this.id,
    required this.name,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
    this.imageUrl,
  });

  factory FruitModel.fromJson(Map<String, dynamic> json) {
    return FruitModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      family: json['family'] ?? '',
      order: json['order'] ?? '',
      genus: json['genus'] ?? '',
      nutritions: NutritionModel.fromJson(json['nutritions'] ?? {}),
      imageUrl: null, // Inicia nulo, lo cargaremos dinámicamente en la UI
    );
  }
}