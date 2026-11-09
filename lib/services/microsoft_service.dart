import 'dart:convert';
import 'package:http/http.dart' as http;

class MicrosoftService {
  final String apiKey = 'TU_API_KEY_DE_MICROSOFT';  // Reemplaza con tu clave de API
  final String url = 'https://<tu-region>.api.cognitive.microsoft.com/text/analytics/v3.0/sentiment';

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Ocp-Apim-Subscription-Key": apiKey,
      },
      body: json.encode({
        "documents": [
          {
            "language": "es",
            "id": "1",
            "text": text,
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to analyze sentiment');
    }
  }
}
