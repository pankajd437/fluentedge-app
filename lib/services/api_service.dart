import 'dart:convert';
import 'package:http/http.dart' as http;

/// API service for FluentEdge backend integration
class ApiService {
  // ======================== CONFIG ========================
  // Base URL for the backend API (use localhost for development)
  static const String baseUrl = 'http://localhost:8000';

  // ====================== API METHODS ======================

  /// Sends user responses to the backend and returns recommended courses
  static Future<Map<String, dynamic>> saveUserResponses({
    required String name,
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required String dailyTime,
    required String learningTimeline,
    required int age,
    required String gender,
  }) async {
    final url = Uri.parse('$baseUrl/save-responses');

    // Prepare JSON body
    final body = jsonEncode({
      'name': name,
      'motivation': motivation,
      'english_level': englishLevel,
      'learning_style': learningStyle,
      'difficulty_area': difficultyArea,
      'daily_time': dailyTime,
      'learning_timeline': learningTimeline,
      'age': age,
      'gender': gender,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // ✅ Successfully received response
        return jsonDecode(response.body);
      } else {
        // ❌ Backend returned an error
        final error = jsonDecode(response.body);
        throw Exception(
          'Failed to save user responses.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
        );
      }
    } catch (e) {
      // ❌ Network or serialization issue
      throw Exception('Error occurred while saving responses: $e');
    }
  }
}
