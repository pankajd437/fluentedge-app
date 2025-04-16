import 'package:hive_flutter/hive_flutter.dart';

/// A hybrid static + singleton approach:
/// - You can still call static methods like `setUserName(...)`.
/// - You can also reference `UserState.instance.userName` synchronously 
///   (once you've called `UserState.init()` at app startup).
class UserState {
  // ------------------------------------------------------------------
  // Singleton pattern so you can do: UserState.instance.userName
  // ------------------------------------------------------------------
  static final UserState instance = UserState._internal();
  UserState._internal();

  // In-memory fallback for the user's name
  // (this will be updated once we call init() or setUserName())
  String userName = 'Friend';

  // ------------------------------------------------------------------
  // Hive Box Definitions
  // ------------------------------------------------------------------
  static const String _boxName = 'user_state';

  static Future<Box> get _box async => Hive.openBox(_boxName);

  /// Call this once early in your app (e.g., main.dart) so that 
  /// `UserState.instance.userName` is populated from Hive.
  static Future<void> init() async {
    final box = await _box;
    instance.userName = box.get('user_name', defaultValue: 'Friend');
  }

  // ------------------------------------------------------------------
  // Synchronous method to get userName (required by UI)
  // ------------------------------------------------------------------
  static String getUserNameSync() {
    return instance.userName;
  }

  // ------------------------------------------------------------------
  // Locale (language code: en / hi)
  // ------------------------------------------------------------------
  static Future<void> setLocale(String localeCode) async {
    final box = await _box;
    await box.put('locale', localeCode);
  }

  static Future<String?> getLocale() async {
    final box = await _box;
    return box.get('locale', defaultValue: 'en');
  }

  // ------------------------------------------------------------------
  // User Name
  // ------------------------------------------------------------------
  static Future<void> setUserName(String name) async {
    final box = await _box;
    await box.put('user_name', name);
    // Keep in-memory userName in sync
    instance.userName = name;
  }

  static Future<String?> getUserName() async {
    final box = await _box;
    return box.get('user_name');
  }

  // ------------------------------------------------------------------
  // Language Preference (English / हिंदी)
  // ------------------------------------------------------------------
  static Future<void> setLanguagePreference(String languagePreference) async {
    final box = await _box;
    await box.put('language_preference', languagePreference);
  }

  static Future<String?> getLanguagePreference() async {
    final box = await _box;
    return box.get('language_preference', defaultValue: 'English');
  }

  // ------------------------------------------------------------------
  // Gender
  // ------------------------------------------------------------------
  static Future<void> setGender(String gender) async {
    final box = await _box;
    await box.put('gender', gender);
  }

  static Future<String?> getGender() async {
    final box = await _box;
    return box.get('gender');
  }

  // ------------------------------------------------------------------
  // Age
  // ------------------------------------------------------------------
  static Future<void> setAge(int age) async {
    final box = await _box;
    await box.put('age', age);
  }

  static Future<int?> getAge() async {
    final box = await _box;
    return box.get('age');
  }

  // ------------------------------------------------------------------
  // ✅ User Level: beginner / intermediate / advanced
  // ------------------------------------------------------------------
  static Future<void> setUserLevel(String userLevel) async {
    final box = await _box;
    await box.put('user_level', userLevel.toLowerCase());
  }

  static Future<String> getUserLevel() async {
    final box = await _box;
    return box.get('user_level', defaultValue: 'beginner');
  }

  // ------------------------------------------------------------------
  // Reset everything in this user_state box
  // ------------------------------------------------------------------
  static Future<void> clearUserState() async {
    final box = await _box;
    await box.clear();
    // Reset in-memory fallback
    instance.userName = 'Friend';
  }
}
