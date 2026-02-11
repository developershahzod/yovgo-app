import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'saved_favorites';

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
    final favorites = await getFavorites();
    final id = partner['id']?.toString() ?? '';
    if (id.isEmpty) return;
    // Don't add duplicates
    if (favorites.any((f) => f['id']?.toString() == id)) return;
    favorites.insert(0, partner);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(favorites));
  }

  static Future<void> removeFavorite(String partnerId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f['id']?.toString() == partnerId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(favorites));
  }

  static Future<bool> isFavorite(String partnerId) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f['id']?.toString() == partnerId);
  }

  static Future<void> toggleFavorite(Map<String, dynamic> partner) async {
    final id = partner['id']?.toString() ?? '';
    if (id.isEmpty) return;
    if (await isFavorite(id)) {
      await removeFavorite(id);
    } else {
      await addFavorite(partner);
    }
  }
}
