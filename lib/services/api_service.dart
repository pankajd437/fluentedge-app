import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/constants.dart'; // For ApiConfig

/// ✅ API response model
class UserResponseResult {
  final String status;
  final String userId;
  final List<dynamic> recommendedCourses;

  /// ✅ NEW: Include userLevel
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
      userLevel: json['user_level'] ?? 'beginner', // ✅ NEW
    );
  }
}

class CourseDetails {
  final List<dynamic> courses;

  CourseDetails({required this.courses});

  factory CourseDetails.fromJson(Map<String, dynamic> json) {
    return CourseDetails(courses: json['courses'] ?? []);
  }
}

class ApiService {
  // 🌐 Environment setup
  static String baseUrl = ApiConfig.local;
  static const Duration requestTimeout = Duration(seconds: 10);

  static void setEnvironment(String env) {
    switch (env) {
      case 'local':
        baseUrl = ApiConfig.local;
        break;
      case 'staging':
        baseUrl = ApiConfig.staging;
        break;
      case 'prod':
        baseUrl = ApiConfig.production;
        break;
      default:
        baseUrl = ApiConfig.local;
    }
    developer.log('🌐 API environment set to: $env', name: 'ApiService');
  }

  /// 🔁 Save user responses with retry support
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
    while (attempt <= retryCount) {
      try {
        final response = await http
            .post(url, headers: {'Content-Type': 'application/json'}, body: body)
            .timeout(requestTimeout);

        if (response.statusCode == 200) {
          developer.log('✅ saveUserResponses success', name: 'ApiService');
          final decoded = jsonDecode(response.body);
          return UserResponseResult.fromJson(decoded);
        } else {
          final error = jsonDecode(response.body);
          developer.log(
            '❌ Error response from saveUserResponses: ${response.statusCode} - ${response.body}',
            name: 'ApiService',
          );
          throw Exception(
            'Failed to save user responses.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
          );
        }
      } catch (e) {
        developer.log('⚠️ Attempt ${attempt + 1} failed for saveUserResponses: $e', name: 'ApiService');
        if (attempt == retryCount) {
          throw Exception('Error occurred while saving responses: $e');
        }
        attempt++;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('Unable to save user responses after multiple attempts.');
  }

  /// 🔁 Fetch all course details with retry support
  static Future<CourseDetails> fetchAllCourseDetails({int retryCount = 2}) async {
    final url = Uri.parse('$baseUrl/courses/all-details');

    int attempt = 0;
    while (attempt <= retryCount) {
      try {
        final response = await http
            .get(url, headers: {'Accept': 'application/json'})
            .timeout(requestTimeout);

        if (response.statusCode == 200) {
          developer.log('✅ fetchAllCourseDetails success', name: 'ApiService');
          return CourseDetails.fromJson(jsonDecode(response.body));
        } else {
          final error = jsonDecode(response.body);
          developer.log(
            '❌ Error response from fetchAllCourseDetails: ${response.statusCode} - ${response.body}',
            name: 'ApiService',
          );
          throw Exception(
            'Failed to fetch course details.\nStatus: ${response.statusCode}\nMessage: ${error['detail'] ?? response.body}',
          );
        }
      } catch (e) {
        developer.log('⚠️ Attempt ${attempt + 1} failed for fetchAllCourseDetails: $e', name: 'ApiService');
        if (attempt == retryCount) {
          throw Exception('Error occurred while fetching course details: $e');
        }
        attempt++;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('Unable to fetch course details after multiple attempts.');
  }

  // 🔕 Deprecated legacy fetchCourseLessons
}
