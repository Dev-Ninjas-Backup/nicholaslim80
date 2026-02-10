import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage cached preset amounts (latest 4 values)
class PresetAmountsCacheService {
  static const String _cacheKey = 'preset_amounts_cache';

  /// Get cached preset amounts (latest 4)
  static Future<List<double>> getCachedAmounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      
      if (cached == null || cached.isEmpty) {
        return [10.0, 20.0, 40.0, 100.0]; // Default amounts
      }

      final amounts = cached
          .split(',')
          .map((e) => double.tryParse(e) ?? 0.0)
          .where((e) => e > 0)
          .toList();

      // Return latest 4 amounts
      return amounts.length > 4 ? amounts.sublist(amounts.length - 4) : amounts;
    } catch (e) {
      return [10.0, 20.0, 40.0, 100.0]; // Return default on error
    }
  }

  /// Add new amount to cache (keeps latest 4) - removes duplicates
  static Future<void> addAmount(double amount) async {
    try {
      if (amount <= 0) return;

      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      List<double> amounts = [];

      if (cached != null && cached.isNotEmpty) {
        amounts = cached
            .split(',')
            .map((e) => double.tryParse(e) ?? 0.0)
            .where((e) => e > 0)
            .toList();
      }

      // Remove duplicate if already exists (to move it to the end)
      amounts.removeWhere((a) => a == amount);

      // Add new amount to the end
      amounts.add(amount);

      // Keep only latest 4 amounts
      if (amounts.length > 4) {
        amounts = amounts.sublist(amounts.length - 4);
      }

      // Save to cache
      await prefs.setString(
        _cacheKey,
        amounts.join(','),
      );

      debugPrint('✅ Added amount to cache: $amount, Total: $amounts');
    } catch (e) {
      debugPrint('Error saving preset amount: $e');
    }
  }

  /// Clear all cached amounts
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}

