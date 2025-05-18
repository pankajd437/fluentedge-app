import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:fluentedge_app/constants.dart';

class ApiService {
  static const String _baseUrl = ApiConfig.local; // e.g., http://10.0.2.2:8000

  /// ✅ REGISTER user with full required backend structure
  static Future<String> registerUser({
    required String name,
    required String email,
    required int age,
    required String gender,
    required String learning_goal,
    required String language,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/register');

    final body = jsonEncode({
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'learning_goal': learning_goal,
      'language': language,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ registerUser success: ${response.body}');
        final data = jsonDecode(response.body);
        return data['user_id'];
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ registerUser exception: $e');
      rethrow;
    }
  }

  /// ✅ POST profiling data
  static Future<Map<String, dynamic>> saveUserResponses({
    required String userId,
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
    final url = Uri.parse('$_baseUrl/api/v1/user/profile?user_id=$userId');

    final body = jsonEncode({
      'comfort_level': englishLevel,
      'practice_frequency': dailyTime,
      'interests': [], // Placeholder
      'challenges': difficultyArea,
      'proficiency_score': 5,

      // placeholders (not used by backend but available if needed later)
      'name': name,
      'motivation': motivation,
      'learning_style': learningStyle,
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
        debugPrint('✅ saveUserResponses success: $data');
        return data;
      } else {
        throw Exception('saveUserResponses failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ saveUserResponses exception: $e');
      rethrow;
    }
  }

  /// 🔍 (Optional) Health Check
  static Future<bool> checkHealth() async {
    final url = Uri.parse('$_baseUrl/api/v1/health');
    try {
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
