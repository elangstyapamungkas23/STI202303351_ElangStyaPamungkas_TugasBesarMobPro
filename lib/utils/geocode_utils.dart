import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodeUtils {
  static const url = "https://nominatim.openstreetmap.org/reverse";

  static Future<String> getAddress(double lat, double lng) async {
    final uri = Uri.parse("$url?format=jsonv2&lat=$lat&lon=$lng");

    final response =
        await http.get(uri, headers: {"User-Agent": "travel-wisata-lokal-app"});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['display_name'] ?? "Alamat tidak ditemukan";
    }

    return "Alamat gagal diambil";
  }
}
