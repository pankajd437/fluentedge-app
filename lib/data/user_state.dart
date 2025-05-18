import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/constants.dart';

/// --------------------------
/// RIVERPOD XP STATE PROVIDER
/// --------------------------

final xpProvider = StateNotifierProvider<XPNotifier, int>((ref) {
  return XPNotifier();
});

class XPNotifier extends StateNotifier<int> {
  XPNotifier() : super(UserState.instance.totalXP);

  /// Sets XP locally, updates UserState, and saves to Hive.
  void setXP(int value) {
    state = value;
    UserState.instance.totalXP = value;
    UserState.instance._saveXPToLocal(value);
  }

  /// Increments XP, updates UserState, saves to Hive, and increments _lastUnsyncedXP.
  void incrementXP(int amount) {
    state += amount;
    UserState.instance.totalXP = state;
    UserState.instance._lastUnsyncedXP += amount;

    // 🆕 Save to local Hive so it persists on next launch
    UserState.instance._saveXPToLocal(state);
  }

  /// Getter for convenience
  int get currentXP => state;

  /// ✅ Sync with backend using /api/v1/user/progress (instead of /user/xp/save)
  Future<void> syncXPWithBackend() async {
    if (UserState.instance.isGuest) return;

    final userId = await UserState.getUserId() ?? '';
    final userName = UserState.instance.userName;

    if (userId.isEmpty) {
      print("⚠️ No userId => Skipping XP sync to /api/v1/user/progress.");
      return;
    }

    final url = Uri.parse("${ApiConfig.local}/api/v1/user/progress");
    final body = {
      "user_id": userId,
      "user_name": userName,
      // Provide a dummy 'lesson_id' so the backend can accept it
      "lesson_id": "live_xp_sync", 
      "xp_earned": state,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        UserState.instance._lastUnsyncedXP = 0;
        print("✅ XP synced to backend (progress). Server says: ${response.body}");
      } else {
        print("❌ XP sync failed: ${response.statusCode} → ${response.body}");
      }
    } catch (e) {
      print("❌ XP sync error: $e");
    }
  }
}

/// -------------------------------------
/// MAIN USER STATE (Singleton + Hive)
/// -------------------------------------
class UserState {
  static final UserState instance = UserState._internal();
  UserState._internal();

  static const String _boxName = 'user_state';
  static Future<Box> get _box async => Hive.openBox(_boxName);

  // ✅ Fallbacks
  String userName = 'Friend';
  bool isGuest = true;

  // ✅ Progress fields
  int dailyStreak = 0;
  int totalXP = 0;
  int completedLessons = 0;

  // ✅ Unsynced XP for delayed backend sync
  int _lastUnsyncedXP = 0;

  /// ---------------------------
  /// 🟦 Initialization
  /// ---------------------------
  static Future<void> init() async {
    final box = await _box;

    instance.userName = box.get('user_name', defaultValue: 'Friend');
    instance.isGuest = box.get('is_guest', defaultValue: true);

    // 🆕 Load XP from local Hive
    final storedXP = box.get('xp', defaultValue: 0) as int;
    instance.totalXP = storedXP;
  }

  static String getUserNameSync() {
    return instance.userName;
  }

  /// ---------------------------
  /// 🟨 Registration
  /// ---------------------------
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

  /// ---------------------------
  /// 🟩 Profiling / Preference
  /// ---------------------------
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

  /// ---------------------------
  /// 🧪 Guest Flag
  /// ---------------------------
  static Future<void> setIsGuest(bool value) async {
    final box = await _box;
    await box.put('is_guest', value);
    instance.isGuest = value;
  }

  static Future<bool> getIsGuest() async {
    final box = await _box;
    return box.get('is_guest', defaultValue: true);
  }

  /// ---------------------------
  /// 🧾 Progress from backend
  /// ---------------------------
  Future<void> loadUserProgressFromBackend() async {
    if (isGuest) return;

    final name = userName;
    final streakUrl = Uri.parse("${ApiConfig.local}/api/v1/user/streak?name=$name");
    final xpUrl = Uri.parse("${ApiConfig.local}/api/v1/user/xp?name=$name");
    final lessonsUrl = Uri.parse("${ApiConfig.local}/api/v1/user/lessons?name=$name");

    try {
      final streakRes = await http.get(streakUrl);
      final xpRes = await http.get(xpUrl);
      final lessonRes = await http.get(lessonsUrl);

      if (streakRes.statusCode == 200) {
        dailyStreak = (jsonDecode(streakRes.body)['streak'] ?? 0);
      }

      if (xpRes.statusCode == 200) {
        totalXP = (jsonDecode(xpRes.body)['total_xp'] ?? 0);
        // 🆕 Update local Hive so we keep the server's updated XP
        await _saveXPToLocal(totalXP);
      }

      if (lessonRes.statusCode == 200) {
        completedLessons = (jsonDecode(lessonRes.body)['completed_lessons'] ?? 0);
      }
    } catch (e) {
      print("❌ Error loading user progress: $e");
    }
  }

  /// ---------------------------
  /// 🧼 Clear All
  /// ---------------------------
  static Future<void> clearUserState() async {
    final box = await _box;
    await box.clear();
    instance.userName = 'Friend';
    instance.isGuest = true;
  }

  /// ---------------------------
  /// 🧾 Debug Full Profile
  /// ---------------------------
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
      'is_guest': box.get('is_guest', defaultValue: true),
    };
  }

  /// ---------------------------
  /// 🏡 Private Helper
  /// ---------------------------
  Future<void> _saveXPToLocal(int xp) async {
    final box = await _box;
    await box.put('xp', xp);
    // debugPrint("💾 Saved XP to Hive: $xp");
  }
}
