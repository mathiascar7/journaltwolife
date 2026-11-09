import 'dart:convert';
import 'package:http/http.dart' as http;

class TextRazorService {
  final String apiKey = 'e5a8e159c559443a6290c0e9495efe2a22190b5be84fe9355159c139'; // Asegúrate de que la clave API esté segura

  Future<Map<String, dynamic>> analyzeText(String text) async {
    final url = Uri.parse('https://api.textrazor.com/');

    try {
      final response = await http.post(
        url,
        headers: {
          'x-textrazor-key': apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'text': text,
          'extractors': 'entities,topics,tone', // Selección de extractores
        },
      );

      if (response.statusCode == 200) {
        // Imprime la respuesta completa para depuración
        print('Respuesta completa: ${response.body}');

        // Verificar que la respuesta contiene la clave "response"
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          throw Exception('La respuesta de la API no contiene el campo "response" esperado.');
        }
      } else {
        // Manejar el error de respuesta
        throw Exception('Error al realizar la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores en caso de problemas de red u otros
      throw Exception('Error en la conexión: $e');
    }
  }
}
