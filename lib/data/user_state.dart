import 'package:hive_flutter/hive_flutter.dart';

/// A hybrid static + singleton approach to access persistent user data.
class UserState {
  static final UserState instance = UserState._internal();
  UserState._internal();

  static const String _boxName = 'user_state';

  static Future<Box> get _box async => Hive.openBox(_boxName);

  // ✅ Fallback for UI before Hive loads
  String userName = 'Friend';

  // ------------------------------------------------------------------
  // 🟦 Initialization at app start
  // ------------------------------------------------------------------
  static Future<void> init() async {
    final box = await _box;
    instance.userName = box.get('user_name', defaultValue: 'Friend');
  }

  static String getUserNameSync() {
    return instance.userName;
  }

  // ------------------------------------------------------------------
  // 🟨 Registration Data
  // ------------------------------------------------------------------
  static Future<void> setUserId(String userId) async {
    final box = await _box;
    await box.put('user_id', userId);
  }

  static Future<String?> getUserId() async {
    final box = await _box;
    return box.get('user_id');
  }

  static Future<void> setUserName(String name) async {
    final box = await _box;
    await box.put('user_name', name);
    instance.userName = name;
  }

  static Future<String?> getUserName() async {
    final box = await _box;
    return box.get('user_name');
  }

  static Future<void> setEmail(String email) async {
    final box = await _box;
    await box.put('email', email);
  }

  static Future<String?> getEmail() async {
    final box = await _box;
    return box.get('email');
  }

  static Future<void> setGender(String gender) async {
    final box = await _box;
    await box.put('gender', gender);
  }

  static Future<String?> getGender() async {
    final box = await _box;
    return box.get('gender');
  }

  static Future<void> setAge(String ageGroup) async {
    final box = await _box;
    await box.put('age_group', ageGroup);
  }

  static Future<String?> getAge() async {
    final box = await _box;
    return box.get('age_group');
  }

  static Future<void> setLearningGoal(String goal) async {
    final box = await _box;
    await box.put('learning_goal', goal);
  }

  static Future<String?> getLearningGoal() async {
    final box = await _box;
    return box.get('learning_goal');
  }

  // ------------------------------------------------------------------
  // 🟩 Profiling / Recommendation
  // ------------------------------------------------------------------
  static Future<void> setUserLevel(String level) async {
    final box = await _box;
    await box.put('user_level', level.toLowerCase());
  }

  static Future<String> getUserLevel() async {
    final box = await _box;
    return box.get('user_level', defaultValue: 'beginner');
  }

  static Future<void> setLanguagePreference(String lang) async {
    final box = await _box;
    await box.put('language_preference', lang);
  }

  static Future<String> getLanguagePreference() async {
    final box = await _box;
    return box.get('language_preference', defaultValue: 'English');
  }

  static Future<void> setLocale(String code) async {
    final box = await _box;
    await box.put('locale', code);
  }

  static Future<String?> getLocale() async {
    final box = await _box;
    return box.get('locale', defaultValue: 'en');
  }

  // ------------------------------------------------------------------
  // 🧼 Reset all user data
  // ------------------------------------------------------------------
  static Future<void> clearUserState() async {
    final box = await _box;
    await box.clear();
    instance.userName = 'Friend';
  }

  // ------------------------------------------------------------------
  // 🧾 Get full user profile (for analytics, debugging, etc.)
  // ------------------------------------------------------------------
  static Future<Map<String, dynamic>> getAllUserProfile() async {
    final box = await _box;
    return {
      'user_id': box.get('user_id'),
      'user_name': box.get('user_name'),
      'email': box.get('email'),
      'gender': box.get('gender'),
      'age_group': box.get('age_group'),
      'learning_goal': box.get('learning_goal'),
      'user_level': box.get('user_level'),
      'language_preference': box.get('language_preference'),
      'locale': box.get('locale'),
    };
  }
}
