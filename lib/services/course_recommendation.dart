import 'package:fluentedge_app/services/api_service.dart';

/// Service to retrieve a user's personalized course recommendations
/// by delegating to the backend algorithm.
class CourseRecommendationService {
  /// Fetches and returns a list of recommended course titles for [userId].
  /// 
  /// Internally this calls GET $baseUrl/user/{userId}/recommendations
  /// and returns the `recommendedCourses` field.
  static Future<List<String>> fetchRecommendedCourses({
    required String userId,
  }) async {
    final result = await ApiService.getUserRecommendations(userId: userId);
    // The backend returns `recommendedCourses` as List<dynamic>,
    // so cast each to String here:
    return List<String>.from(result.recommendedCourses);
  }
}
