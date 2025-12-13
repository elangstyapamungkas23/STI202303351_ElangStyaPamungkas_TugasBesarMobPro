import 'package:shared_preferences/shared_preferences.dart';

class FavoriteUtils {
  static Future<void> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("favorite_places") ?? [];

    if (list.contains(id.toString())) {
      list.remove(id.toString());
    } else {
      list.add(id.toString());
    }

    await prefs.setStringList("favorite_places", list);
  }

  static Future<bool> isFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("favorite_places") ?? [];

    return list.contains(id.toString());
  }

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("favorite_places") ?? [];

    return list.map((e) => int.parse(e)).toList();
  }
}
