import 'package:geolocator/geolocator.dart';

class GetPosition {
  static Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // cek apakah GPS hidup
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw "GPS tidak aktif. Aktifkan dulu lokasi HP.";
    }

    // cek izin aplikasi
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw "Izin lokasi ditolak.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Izin lokasi ditolak permanen. Buka Pengaturan > Izin Aplikasi.";
    }

    // ambil posisi
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
