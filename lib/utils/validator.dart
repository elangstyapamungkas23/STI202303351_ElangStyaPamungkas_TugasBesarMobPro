class Validator {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Tidak boleh kosong";
    }
    return null;
  }

  static String? isDouble(String? value) {
    if (value == null || value.trim().isEmpty) return "Tidak boleh kosong";
    if (double.tryParse(value) == null) return "Harus berupa angka";
    return null;
  }
}
