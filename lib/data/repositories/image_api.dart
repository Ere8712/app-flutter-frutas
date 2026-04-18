import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageApi {
  static const String _baseUrl = 'https://api.pexels.com/v1/search';
  
  // IMPORTANTE: Nunca subas tu API Key real a repositorios públicos como GitHub.
  // Lo ideal es usar variables de entorno (.env), pero lo dejaremos así por simplicidad ahora.
  static const String _apiKey = 'kN3T7fLbI8WIhL2vilWCNXotc8ZHVHuSyCA5cGCWW44xhsYXe4HtJ6iR'; 

  /// Busca una imagen basándose en el nombre de la fruta y devuelve la URL.
  Future<String?> fetchFruitImageUrl(String fruitName) async {
    try {
      // Buscamos solo 1 imagen por página para ahorrar datos y ser rápidos
      final url = Uri.parse('$_baseUrl?query=$fruitName%20fruit&per_page=1');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Verificamos que Pexels haya encontrado al menos una imagen
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          // Extraemos la URL de tamaño mediano (ideal para tarjetas móviles)
          return data['photos'][0]['src']['medium'];
        }
        return null; // No se encontró imagen para esa fruta
      } else {
        print('Error de Pexels: ${response.statusCode}');
        return null; // Devolvemos null para que la UI muestre un placeholder de error
      }
    } catch (e) {
      print('Error de conexión con Pexels: $e');
      return null;
    }
  }
}