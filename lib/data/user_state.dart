import 'package:hive_flutter/hive_flutter.dart';

class UserState {
  static const String _boxName = 'user_state';

  static Future<Box> get _box async => Hive.openBox(_boxName);

  /// Save locale (language preference)
  static Future<void> setLocale(String localeCode) async {
    final box = await _box;
    await box.put('locale', localeCode);
  }

  static Future<String?> getLocale() async {
    final box = await _box;
    return box.get('locale', defaultValue: 'en');
  }

  /// Save user name
  static Future<void> setUserName(String name) async {
    final box = await _box;
    await box.put('user_name', name);
  }

  static Future<String?> getUserName() async {
    final box = await _box;
    return box.get('user_name');
  }

  /// Save language preference
  static Future<void> setLanguagePreference(String languagePreference) async {
    final box = await _box;
    await box.put('language_preference', languagePreference);
  }

  static Future<String?> getLanguagePreference() async {
    final box = await _box;
    return box.get('language_preference', defaultValue: 'English');
  }

  /// Save user gender
  static Future<void> setGender(String gender) async {
    final box = await _box;
    await box.put('gender', gender);
  }

  static Future<String?> getGender() async {
    final box = await _box;
    return box.get('gender');
  }

  /// Save user age
  static Future<void> setAge(int age) async {
    final box = await _box;
    await box.put('age', age);
  }

  static Future<int?> getAge() async {
    final box = await _box;
    return box.get('age');
  }

  /// Clear user state
  static Future<void> clearUserState() async {
    final box = await _box;
    await box.clear();
  }
}
