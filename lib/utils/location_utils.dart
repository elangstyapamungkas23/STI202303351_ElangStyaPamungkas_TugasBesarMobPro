// lib/utils/location_utils.dart
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  /// Returns current position or throws a descriptive error.
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          "GPS tidak aktif. Aktifkan GPS pada pengaturan perangkat.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Izin lokasi ditolak oleh user.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Izin lokasi ditolak permanen. Buka pengaturan aplikasi.");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
