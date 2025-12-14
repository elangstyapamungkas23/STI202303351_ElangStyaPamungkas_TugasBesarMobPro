import 'package:shared_preferences/shared_preferences.dart';

class ReviewUtils {
  static Future<void> addReview(int id, String text) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("review_$id") ?? [];

    list.add(text);
    await prefs.setStringList("review_$id", list);
  }

  static Future<List<String>> getReviews(int id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("review_$id") ?? [];
  }
}
