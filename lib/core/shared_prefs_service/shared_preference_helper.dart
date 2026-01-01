import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  static const String _tokenKey = 'token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================= EXISTING SAFE METHODS =================

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(_isLoggedInKey, value);
  }

  static bool get isLoggedIn {
    return _prefs?.getBool(_isLoggedInKey) ?? false;
  }

  // ================= NEW (REQUIRED) =================

  static Future<void> saveUserEmail(String email) async {
    await _prefs?.setString(_userEmailKey, email);
  }

  static String? getUserEmail() {
    return _prefs?.getString(_userEmailKey);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
