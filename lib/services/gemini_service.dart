import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyCrn2OdWn50qMCA9dmvj5Vj5SMg__UJm8M';

  Future<Map<String, dynamic>> analyzeText(String text, String languageCode) async {
    // 1. URL con el modelo exacto que te funcionaba: gemini-2.5-flash
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey'
    );

    // 2. Prompt con integración de idioma dinámico
    final String promptProfesional = """
Rol: Actúas como un especialista en análisis de sentimiento y psicometría lingüística.
Tarea: Analizar la entrada de diario y responder en el idioma: $languageCode.

INSTRUCCIÓN TÉCNICA CRÍTICA:
Para el campo "categoria", utiliza EXCLUSIVAMENTE las siguientes claves en inglés según corresponda:

Mapeo de Categorías Negativas:
- Bullying -> bullying
- Depresión -> depression
- Ansiedad -> anxiety
- Trastornos de imagen corporal -> body_image
- Cyberbullying -> cyberbullying
- Dificultades relacionales -> relationship_problems
- Problemas académicos -> academic_problems
- Estrés crónico -> chronic_stress
- Adicciones -> addictions
- Eventos traumáticos/violentos -> traumatic_events
- Desconfianza/Paranoia -> distrust
- Maltrato -> abuse
- Acoso sexual -> sexual_harassment

Mapeo de Categorías Positivas:
- Motivación -> motivation
- Amistades saludables -> healthy_friendships
- Superación -> overcoming
- Diversión -> fun
- Gratitud -> gratitude
- Amor propio -> self_love
- Altruismo -> altruism
- Éxitos académicos/personales -> personal_achievements
- Crecimiento espiritual -> spiritual_growth
- Optimismo -> optimism
- Mindfulness -> mindfulness
- Resolución de conflictos -> conflict_resolution
- Deporte/Arte -> sports_art

RESPONDE ÚNICAMENTE CON EL SIGUIENTE FORMATO JSON PURO:
{
 "analisis_general": "Resumen breve en primera persona, empático y humano, en idioma $languageCode.",
 "detecciones_negativas": [
   {"categoria": "clave_en_ingles", "evidencia_textual": "fragmento del texto", "nivel_riesgo": 1-5}
 ],
 "detecciones_positive": [
   {"categoria": "clave_en_ingles", "evidencia_textual": "fragmento del texto", "fuerza": 1-5}
 ],
 "alertas_criticas": false
}

Texto a analizar: "$text"
""";

    try {
      final body = json.encode({
        "contents": [{
          "parts": [{"text": promptProfesional}]
        }],
        "generationConfig": {
          "temperature": 0.2,
          "topP": 0.8,
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String rawText = data['candidates'][0]['content']['parts'][0]['text'];

        // --- FILTRO DE EXTRACCIÓN DE JSON (Tu lógica original) ---
        int startIndex = rawText.indexOf('{');
        int endIndex = rawText.lastIndexOf('}');

        if (startIndex != -1 && endIndex != -1) {
          String cleanedJson = rawText.substring(startIndex, endIndex + 1);
          return json.decode(cleanedJson);
        } else {
          throw Exception("No se encontró estructura JSON");
        }
      } else {
        print("Cuerpo del error API: ${response.body}");
        throw Exception("Error de conexión: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en GeminiService: $e");
      return {
        "analisis_general": "No se pudo generar el análisis automático.",
        "detecciones_negativas": [],
        "detecciones_positive": [],
        "alertas_criticas": false
      };
    }
  }
}