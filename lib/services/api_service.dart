import 'dart:convert';
import 'package:http/http.dart' as http;

/// API service for FluentEdge backend integration
class ApiService {
  // ======================== CONFIG ========================
  static const String baseUrl = 'http://localhost:8000/api/v1';

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
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "status": data['status'],
          "user_id": data['user_id'],
          "recommended_courses": data['recommended_courses'] ?? [],
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'Failed to save user responses.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error occurred while saving responses: $e');
    }
  }

  /// Fetch all course details (used in course list pages)
  static Future<List<dynamic>> fetchAllCourseDetails() async {
    final url = Uri.parse('$baseUrl/courses/all-details');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['courses'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'Failed to fetch course details.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error occurred while fetching all course details: $e');
    }
  }

  // ====================== UNUSED METHODS ======================
  /*
  /// Fetch lessons of a specific course [Deprecated: Using local data instead]
  static Future<List<dynamic>> fetchCourseLessons(String courseTitle) async {
    final url = Uri.parse('$baseUrl/courses/lessons?title=${Uri.encodeComponent(courseTitle)}');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['lessons'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'Failed to fetch lessons.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error occurred while fetching lessons: $e');
    }
  }
  */
}
