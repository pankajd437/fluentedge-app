import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/constants.dart';

/// ✅ Represents the result returned by both the profiling and recommendations APIs.
class UserResponseResult {
  final String status;
  final String userId;
  final List<dynamic> recommendedCourses;
  final String userLevel;

  UserResponseResult({
    required this.status,
    required this.userId,
    required this.recommendedCourses,
    required this.userLevel,
  });

  factory UserResponseResult.fromJson(Map<String, dynamic> json) {
    return UserResponseResult(
      status: json['status'].toString(),
      userId: json['user_id'].toString(),
      recommendedCourses: json['recommended_courses'] ?? [],
      userLevel: json['user_level'] ?? 'beginner',
    );
  }
}

/// ✅ Represents the list of all courses (for dashboards, etc.)
class CourseDetails {
  final List<dynamic> courses;

  CourseDetails({required this.courses});

  factory CourseDetails.fromJson(Map<String, dynamic> json) {
    return CourseDetails(courses: json['courses'] ?? []);
  }
}

class ApiService {
  /// Base URL (can be switched via setEnvironment)
  static String baseUrl = ApiConfig.local;
  static const Duration requestTimeout = Duration(seconds: 10);

  /// 👉 Switch between local / staging / production
  static void setEnvironment(String env) {
    baseUrl = switch (env) {
      'staging' => ApiConfig.staging,
      'prod'    => ApiConfig.production,
      _         => ApiConfig.local,
    };
    developer.log('🌐 API environment set to: $env', name: 'ApiService');
  }

  // ────────────────────────────
  // 1) Registration endpoint
  // ────────────────────────────

  /// Registers a new user in the backend.
  static Future<void> registerUser({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String goal,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'age_group': ageGroup,
      'gender': gender,
      'goal': goal,
    });

    try {
      final res = await http
          .post(url, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(requestTimeout);

      if (res.statusCode == 200 || res.statusCode == 201) {
        developer.log('✅ registerUser success', name: 'ApiService');
      } else {
        final error = jsonDecode(res.body);
        throw Exception('Registration failed: ${error['detail'] ?? res.body}');
      }
    } catch (e) {
      developer.log('❌ registerUser error: $e', name: 'ApiService');
      rethrow;
    }
  }

  // ────────────────────────────
  // 2) Profiling endpoint
  // ────────────────────────────

  /// Saves the user’s profiling/chart responses and returns initial recommendations.
  static Future<UserResponseResult> saveUserResponses({
    required String name,
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required String dailyTime,
    required String learningTimeline,
    required int age,
    required String gender,
    int retryCount = 2,
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

    int attempt = 0;
    while (true) {
      try {
        final res = await http
            .post(url, headers: {'Content-Type': 'application/json'}, body: body)
            .timeout(requestTimeout);

        if (res.statusCode == 200) {
          developer.log('✅ saveUserResponses success', name: 'ApiService');
          return UserResponseResult.fromJson(jsonDecode(res.body));
        } else {
          final error = jsonDecode(res.body);
          developer.log(
            '❌ saveUserResponses error ${res.statusCode}: ${res.body}',
            name: 'ApiService',
          );
          throw Exception(
            'Failed to save responses (${res.statusCode}): ${error['detail'] ?? res.body}',
          );
        }
      } catch (e) {
        if (attempt++ >= retryCount) {
          developer.log('⚠️ saveUserResponses giving up: $e', name: 'ApiService');
          rethrow;
        }
        developer.log('🔄 retry saveUserResponses #$attempt', name: 'ApiService');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // ────────────────────────────
  // 3) Recommendations endpoint
  // ────────────────────────────

  /// Fetches the user’s personalized course recommendations.
  /// GET /user/{userId}/recommendations
  static Future<UserResponseResult> getUserRecommendations({
    required String userId,
    int retryCount = 2,
  }) async {
    final url = Uri.parse('$baseUrl/user/$userId/recommendations');
    int attempt = 0;

    while (true) {
      try {
        final res = await http
            .get(url, headers: {'Accept': 'application/json'})
            .timeout(requestTimeout);

        if (res.statusCode == 200) {
          developer.log('✅ getUserRecommendations success', name: 'ApiService');
          return UserResponseResult.fromJson(jsonDecode(res.body));
        } else {
          throw Exception('Failed to fetch recommendations: ${res.body}');
        }
      } catch (e) {
        if (attempt++ >= retryCount) {
          developer.log('⚠️ getUserRecommendations giving up: $e', name: 'ApiService');
          rethrow;
        }
        developer.log('🔄 retry getUserRecommendations #$attempt', name: 'ApiService');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // ────────────────────────────
  // 4) Course catalog endpoint
  // ────────────────────────────

  /// Retrieves the full list of available courses.
  static Future<CourseDetails> fetchAllCourseDetails({int retryCount = 2}) async {
    final url = Uri.parse('$baseUrl/courses/all-details');
    int attempt = 0;

    while (true) {
      try {
        final res = await http
            .get(url, headers: {'Accept': 'application/json'})
            .timeout(requestTimeout);

        if (res.statusCode == 200) {
          developer.log('✅ fetchAllCourseDetails success', name: 'ApiService');
          return CourseDetails.fromJson(jsonDecode(res.body));
        } else {
          final error = jsonDecode(res.body);
          throw Exception('Failed to fetch courses: ${error['detail'] ?? res.body}');
        }
      } catch (e) {
        if (attempt++ >= retryCount) {
          developer.log('⚠️ fetchAllCourseDetails giving up: $e', name: 'ApiService');
          rethrow;
        }
        developer.log('🔄 retry fetchAllCourseDetails #$attempt', name: 'ApiService');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
