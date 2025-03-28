import 'dart:convert';
import 'package:http/http.dart' as http;

// Define the API base URL
class ApiService {
  // Ideally, baseUrl should be configurable for different environments
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Define a method to save user responses to the server
  static Future<Map<String, dynamic>> saveUserResponses({
    required String name,
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required String dailyTime,
    required String learningTimeline,
    required int age,         // Added age
    required String gender,   // Added gender
  }) async {
    final url = Uri.parse('$baseUrl/save-responses');

    // Constructing the body for the POST request
    final body = jsonEncode({
      'name': name,
      'motivation': motivation,
      'english_level': englishLevel,
      'learning_style': learningStyle,
      'difficulty_area': difficultyArea,
      'daily_time': dailyTime,
      'learning_timeline': learningTimeline,
      'age': age,             // Include age in the request body
      'gender': gender,       // Include gender in the request body
    });

    // Sending the POST request
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Checking if the response status is OK (200)
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the decoded response body
      } else {
        // Handling errors
        throw Exception(
            'Failed to save user responses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handling connection or other errors
      throw Exception('Error occurred while saving responses: $e');
    }
  }
}
