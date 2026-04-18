import 'package:flutter/material.dart';
import '../../data/models/fruit_model.dart';
import '../../data/repositories/fruityvice_api.dart';
import '../../data/repositories/image_api.dart';
import '../../data/models/cocktail_model.dart';

class FruitProvider extends ChangeNotifier {
  final FruityviceApi _fruitApi = FruityviceApi();
  final ImageApi _imageApi = ImageApi();

  List<FruitModel> fruits = [];
  bool isLoading = true;
  String errorMessage = '';

  FruitProvider() {
    loadFruits(); // Carga las frutas automáticamente al iniciar la app
  }

  Future<void> loadFruits() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      fruits = await _fruitApi.fetchAllFruits();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al cargar el catálogo: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  List<FruitModel> _selectedFruits = [];
  BowlSize _currentBowlSize = BowlSize.small;

  List<FruitModel> get selectedFruits => _selectedFruits;
  BowlSize get currentBowlSize => _currentBowlSize;

  // Getter que crea "al vuelo" el modelo con los cálculos exactos
  CocktailModel get currentCocktail => CocktailModel(
        id: 'current_mix',
        selectedFruits: _selectedFruits,
        size: _currentBowlSize,
      );

  void setBowlSize(BowlSize size) {
    _currentBowlSize = size;
    notifyListeners();
  }

  void toggleFruitSelection(FruitModel fruit) {
    if (_selectedFruits.contains(fruit)) {
      _selectedFruits.remove(fruit);
    } else {
      _selectedFruits.add(fruit);
    }
    notifyListeners();
  }

  void clearCocktail() {
    _selectedFruits.clear();
    _currentBowlSize = BowlSize.small;
    notifyListeners();
  }

  /// Método para cargar la imagen de una fruta solo cuando se muestra en pantalla (Lazy Loading)
  Future<String?> loadFruitImage(FruitModel fruit) async {
    // Si ya la descargamos antes, no volvemos a gastar la petición a la API
    if (fruit.imageUrl != null) return fruit.imageUrl; 
    
    final url = await _imageApi.fetchFruitImageUrl(fruit.name);
    fruit.imageUrl = url; // Guardamos la URL en el modelo para caché
    return url;
  }
}