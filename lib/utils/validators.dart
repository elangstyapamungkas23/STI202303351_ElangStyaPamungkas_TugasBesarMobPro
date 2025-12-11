class Validators {
  static bool isNotEmpty(String? v) => v != null && v.trim().isNotEmpty;
  static double? parseDouble(String? v) {
    if (v == null) return null;
    return double.tryParse(v.trim());
  }
}
