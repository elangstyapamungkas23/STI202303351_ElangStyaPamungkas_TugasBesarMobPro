import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../models/lokasi_model.dart';

// Controller & Model tambahan
import '../controllers/favorite_controller.dart';
import '../controllers/review_controller.dart';
import '../models/favorite_model.dart';
import '../pages/favorite_page.dart';
import '../pages/review_page.dart';

class DetailPage extends StatefulWidget {
  final LokasiModel data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double? jarak;

  final FavoriteController favC = Get.put(FavoriteController());
  final ReviewController reviewC = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    _hitungJarak();
  }

  // ======================================================
  //              UPGRADE TANPA MENGUBAH KODE LAMA
  // ======================================================
  Future<void> _hitungJarak() async {
    try {
      // Cek permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition();

      double jrk = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        widget.data.latitude,
        widget.data.longitude,
      );

      // Anti error "setState called after dispose"
      if (!mounted) return;

      // ====== KODE LAMA TETAP ======
      setState(() => jarak = jrk / 1000);
      // =============================
    } catch (e) {
      debugPrint("Error hitung jarak: $e");
    }
  }

  Future<void> _openGoogleMapsRoute() async {
    final url =
        "https://www.google.com/maps/dir/?api=1&destination=${widget.data.latitude},${widget.data.longitude}&travelmode=driving";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  String estimasiWaktu(double km, double speed) {
    double jam = km / speed;
    int menit = (jam * 60).round();
    return "$menit menit";
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(d.nama),
              background: Image.file(
                File(d.foto!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.nama,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(d.alamat ?? "-"),
                  const SizedBox(height: 12),
                  Text(
                    "Koordinat: (${d.latitude}, ${d.longitude})",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  jarak == null
                      ? const CircularProgressIndicator()
                      : Text(
                          "Jarak dari posisi Anda: ${jarak!.toStringAsFixed(2)} km",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(height: 20),
                  if (jarak != null) ...[
                    Text(
                      "Estimasi waktu tempuh:",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text("🚶 Jalan kaki: ${estimasiWaktu(jarak!, 5)}"),
                    Text("🏍 Motor: ${estimasiWaktu(jarak!, 40)}"),
                    Text("🚗 Mobil: ${estimasiWaktu(jarak!, 60)}"),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: _openGoogleMapsRoute,
                    icon: const Icon(Icons.directions),
                    label: const Text("Lihat Rute di Google Maps"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () {
                      favC.toggleFavorite(
                        FavoriteModel(
                          title: d.nama,
                          image: d.foto!,
                          description: d.alamat ?? "-",
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            favC.isFavorite(d.nama)
                                ? "Ditambahkan ke Favorite"
                                : "Dihapus dari Favorite",
                          ),
                        ),
                      );

                      Navigator.pushNamed(context, '/favorite');
                    },
                    icon: Obx(() => Icon(
                          favC.isFavorite(d.nama)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                        )),
                    label: const Text("Favorite / Unfavorite"),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/review',
                        arguments: d.nama,
                      );
                    },
                    icon: const Icon(Icons.reviews),
                    label: const Text("Lihat Review Pengunjung"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(d.latitude, d.longitude),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("lokasi"),
                    position: LatLng(d.latitude, d.longitude),
                    infoWindow: InfoWindow(title: d.nama),
                  )
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
