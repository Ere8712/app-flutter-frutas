import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fruit_model.dart';

class FruityviceApi {
  static const String _baseUrl = 'https://www.fruityvice.com/api/fruit';

  /// Obtiene la lista completa de frutas desde la API.
  Future<List<FruitModel>> fetchAllFruits() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all'));

      if (response.statusCode == 200) {
        // La API devuelve una lista de JSONs
        List<dynamic> data = json.decode(response.body);
        
        // Mapeamos cada elemento del JSON a nuestro FruitModel
        return data.map((json) => FruitModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las frutas: Código ${response.statusCode}');
      }
    } catch (e) {
      // Aquí podrías implementar un sistema de logs más complejo en el futuro
      throw Exception('Error de conexión con Fruityvice: $e');
    }
  }
}