import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:fluentedge_app/constants.dart';
// Include any other imports your ApiService may need, like secure storage, etc.

class ApiService {
  static const String _baseUrl = ApiConfig.local; // or staging/production

  /// Registers a user with the backend
  /// Updated to expect 'learning_goal' instead of 'goal'.
  /// NOW returns the user_id so it can be stored in Hive.
  static Future<String> registerUser({
    required String name,
    required String email,
    required int age,
    required String gender,
    required String learning_goal,
    required String language,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    // JSON body for /api/v1/register
    final body = jsonEncode({
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'learning_goal': learning_goal, // Matches the new backend logic
      'language': language,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // If successful, parse the backend response & return user_id
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ registerUser success: ${response.body}');
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // Return the user_id so registration_page.dart can store it in Hive
        return data['user_id'] as String;
      } else {
        // Keep existing error logic
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ registerUser exception: $e');
      rethrow; // Let the calling function handle it
    }
  }

  /// Saves user profiling responses to the backend to fix the "No named parameter with the name 'name'" error.
  ///
  /// The [profiling_chat_page.dart] calls this with:
  ///  - name, motivation, englishLevel, learningStyle, difficultyArea,
  ///    dailyTime, learningTimeline, age, gender, and userId.
  ///
  /// Your current FastAPI model (UserProfileInput) only explicitly expects:
  ///  comfort_level, practice_frequency, interests, challenges, proficiency_score
  ///
  /// For now, we include the extra placeholders in the JSON so your code compiles.
  /// Adjust or remove these as needed if/when your backend changes.
  static Future<Map<String, dynamic>> saveUserResponses({
    required String userId,
    required String name,            // from profiling_chat_page
    required String motivation,      // placeholder
    required String englishLevel,    // matches "comfort_level"
    required String learningStyle,   // placeholder
    required String difficultyArea,  // matches "challenges"
    required String dailyTime,       // matches "practice_frequency"
    required String learningTimeline,// placeholder
    required int age,                // placeholder
    required String gender,          // placeholder
  }) async {
    // This endpoint is /api/v1/user/profile?user_id=...
    final url = Uri.parse('$_baseUrl/user/profile?user_id=$userId');

    // For now, we'll map these fields to the known fields in your
    // main.py 'UserProfileInput', plus placeholders if you later expand the model.
    // 'interests' is required by your backend, so let's send an empty list or adjust as needed:
    final body = jsonEncode({
      'comfort_level': englishLevel,         // from user input
      'practice_frequency': dailyTime,       // from user input
      'interests': [],                       // you can pass actual user interests if needed
      'challenges': difficultyArea,          
      'proficiency_score': 5,               // placeholder; adjust if needed

      // Extra placeholders:
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
        final data = jsonDecode(response.body) as Map<String, dynamic>;
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

  // ------------------------------------------------
  // Any other existing methods remain here unchanged
  // ------------------------------------------------
}
