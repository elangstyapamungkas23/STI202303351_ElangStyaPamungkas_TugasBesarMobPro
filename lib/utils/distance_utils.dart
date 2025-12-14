import 'dart:math';

class DistanceUtils {
  static double hitungJarakKm(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius (km)

    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _degToRad(double deg) => deg * pi / 180;

  static Map<String, String> estimasiWaktu(double jarakKm) {
    return {
      "jalan": _format(jarakKm / 5), // 5 km/h
      "sepeda": _format(jarakKm / 15),
      "motor": _format(jarakKm / 40),
      "mobil": _format(jarakKm / 60),
      "kereta": _format(jarakKm / 80),
    };
  }

  static String _format(double jam) {
    int menit = (jam * 60).round();
    if (menit < 60) return "$menit menit";
    int h = menit ~/ 60;
    int m = menit % 60;
    return "$h jam $m menit";
  }
}
