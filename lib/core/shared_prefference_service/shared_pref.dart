import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // ================= KEYS =================
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userIdKey = 'userId';
  static const String _selectedRoleKey = 'selectedRole';
  static const String _categoriesKey = 'categories';
  static const String _welcomeDialogKey = 'isDriverVerificationDialogShown';
  static const String _showOnboardKey = 'showOnboard';

  // ================= INTERNAL =================
  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  // ================= AUTH =================

  static Future<void> saveAccessToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _prefs;
    return prefs.getString(_refreshTokenKey);
  }

  /// ✅ SINGLE SOURCE OF TRUTH
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 🔥 Call on logout
  static Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_selectedRoleKey);
  }

  // ================= USER =================

  static Future<void> saveUserId(String id) async {
    final prefs = await _prefs;
    await prefs.setString(_userIdKey, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(_userIdKey);
  }

  // ================= ROLE =================

  static Future<void> saveSelectedRole(String role) async {
    final prefs = await _prefs;
    await prefs.setString(_selectedRoleKey, role);
  }

  static Future<String?> getSelectedRole() async {
    final prefs = await _prefs;
    return prefs.getString(_selectedRoleKey);
  }

  // ================= CATEGORIES =================

  static Future<void> saveCategories(
    List<Map<String, String>> categories,
  ) async {
    final prefs = await _prefs;
    await prefs.setString(_categoriesKey, jsonEncode(categories));
  }

  static Future<List<Map<String, String>>> getCategories() async {
    final prefs = await _prefs;
    final data = prefs.getString(_categoriesKey);
    if (data == null) return [];
    return List<Map<String, String>>.from(jsonDecode(data));
  }

  // ================= UI FLAGS =================

  static Future<void> setWelcomeDialogShown(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_welcomeDialogKey, value);
  }

  static Future<bool> isWelcomeDialogShown() async {
    final prefs = await _prefs;
    return prefs.getBool(_welcomeDialogKey) ?? false;
  }

  static Future<void> setShowOnboard(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_showOnboardKey, value);
  }

  static Future<bool> getShowOnboard() async {
    final prefs = await _prefs;
    return prefs.getBool(_showOnboardKey) ?? false;
  }
}
