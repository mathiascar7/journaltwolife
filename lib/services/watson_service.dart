import 'dart:convert';
import 'package:http/http.dart' as http;

class WatsonService {
  final String apiKey = 'TU_API_KEY_DE_IBM';  // Reemplaza con tu clave de API
  final String url = 'https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/TU_INSTANCIA/tone';

  Future<Map<String, dynamic>> analyzeTone(String text) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic " + base64Encode(utf8.encode('apikey:$apiKey')),
      },
      body: json.encode({
        "text": text,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to analyze tone');
    }
  }
}
