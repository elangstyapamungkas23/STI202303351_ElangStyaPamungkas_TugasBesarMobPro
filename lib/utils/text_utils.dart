class TextUtils {
  static String truncate(String text, int max) {
    if (text.length <= max) return text;
    return text.substring(0, max) + "...";
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
