import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // ================= KEYS =================
  static const String _accessTokenKey = 'accessToken';
  static const String _userIdKey = 'userId';
  static const String _selectedRoleKey = 'selectedRole';
  static const String _categoriesKey = 'categories';
  static const String _welcomeDialogKey = 'isDriverVerificationDialogShown';
  static const String _showOnboardKey = 'showOnboard';

  // ================= AUTH =================

  /// Save access token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);

    // legacy (ignored for auth decision)
    await prefs.setBool('isLogin', true);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// ✅ SINGLE SOURCE OF TRUTH
  static Future<bool> checkLogin() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 🔥 MUST call on logout
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();

    // auth
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_selectedRoleKey);

    // ui flags
    await prefs.remove(_showOnboardKey);
    await prefs.remove(_welcomeDialogKey);

    // legacy cleanup
    await prefs.remove('token');
    await prefs.remove('isLogin');
  }

  // ================= USER =================

  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // ================= ROLE =================

  static Future<void> saveSelectedRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedRoleKey, role);
  }

  static Future<String?> getSelectedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedRoleKey);
  }

  // ================= CATEGORIES =================

  static Future<void> saveCategories(
    List<Map<String, String>> categories,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoriesKey, jsonEncode(categories));
  }

  static Future<List<Map<String, String>>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_categoriesKey);
    if (data == null) return [];
    return List<Map<String, String>>.from(jsonDecode(data));
  }

  // ================= ONBOARD / DIALOG =================

  static Future<void> setWelcomeDialogShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_welcomeDialogKey, value);
  }

  static Future<bool> isWelcomeDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_welcomeDialogKey) ?? false;
  }

  static Future<void> setShowOnboard(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showOnboardKey, value);
  }

  static Future<bool> getShowOnboard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showOnboardKey) ?? false;
  }
}
