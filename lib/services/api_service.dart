import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> saveUserResponses({
    required String name,
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required String dailyTime,
    required String learningTimeline,
  }) async {
    final url = Uri.parse('$baseUrl/save-responses');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'motivation': motivation,
        'english_level': englishLevel,
        'learning_style': learningStyle,
        'difficulty_area': difficultyArea,
        'daily_time': dailyTime,
        'learning_timeline': learningTimeline,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save user responses. Status code: ${response.statusCode}');
    }
  }
}
