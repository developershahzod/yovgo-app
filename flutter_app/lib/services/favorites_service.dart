import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'saved_favorites';

  /// Returns the unique key for a car wash entry.
  /// Uses location_id if available (unique per branch), falls back to id.
  static String _uniqueKey(Map<String, dynamic> item) {
    final locId = item['location_id']?.toString() ?? '';
    if (locId.isNotEmpty) return locId;
    return item['id']?.toString() ?? '';
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addFavorite(Map<String, dynamic> partner) async {
    final key = _uniqueKey(partner);
    if (key.isEmpty) return;
    final favorites = await getFavorites();
    // Don't add duplicates — compare by unique key
    if (favorites.any((f) => _uniqueKey(f) == key)) return;
    favorites.insert(0, Map<String, dynamic>.from(partner));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(favorites));
  }

  static Future<void> removeFavorite(String uniqueKey) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => _uniqueKey(f) == uniqueKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(favorites));
  }

  static Future<bool> isFavorite(String uniqueKey) async {
    final favorites = await getFavorites();
    return favorites.any((f) => _uniqueKey(f) == uniqueKey);
  }

  /// Get the unique key for a partner map (for use in isFavorite checks)
  static String getKey(Map<String, dynamic> partner) => _uniqueKey(partner);

  static Future<void> toggleFavorite(Map<String, dynamic> partner) async {
    final key = _uniqueKey(partner);
    if (key.isEmpty) return;
    if (await isFavorite(key)) {
      await removeFavorite(key);
    } else {
      await addFavorite(partner);
    }
  }
}
