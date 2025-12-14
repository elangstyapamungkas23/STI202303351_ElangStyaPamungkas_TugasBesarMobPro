import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../db/database_helper.dart';
import '../models/lokasi_model.dart';
import '../utils/distance_utils.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController; // 🔥 sudah dipakai nanti
  Set<Marker> _markers = {};
  List<LokasiModel> _dataList = []; // 🔥 akan dipakai juga

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    final data = await DatabaseHelper.instance.readAll();

    // simpan list di memori → dipakai fitur tambahan
    _dataList = data;

    setState(() {
      _markers = data.map((d) {
        return Marker(
          markerId: MarkerId("lokasi_${d.id}"),
          position: LatLng(d.latitude, d.longitude),
          infoWindow: InfoWindow(
            title: d.nama,
            snippet: d.alamat,
          ),
          onTap: () => _onMarkerTap(d),
        );
      }).toSet();
    });
  }

  Future<void> _onMarkerTap(LokasiModel d) async {
    // 🔥 Gunakan mapController supaya warning hilang
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(d.latitude, d.longitude),
        ),
      );
    }

    _showDetail(d);
  }

  Future<void> _showDetail(LokasiModel d) async {
    Position? pos;

    try {
      pos = await Geolocator.getCurrentPosition();
    } catch (_) {
      pos = null;
    }

    double jarak = 0;
    Map<String, String> estimasi = {};

    if (pos != null) {
      jarak = DistanceUtils.hitungJarakKm(
        pos.latitude,
        pos.longitude,
        d.latitude,
        d.longitude,
      );
      estimasi = DistanceUtils.estimasiWaktu(jarak);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(d.nama,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(d.deskripsi ?? "-"),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.place, color: Colors.red),
                  SizedBox(width: 6),
                  Expanded(child: Text(d.alamat ?? "-")),
                ],
              ),
              SizedBox(height: 15),
              if (pos != null) ...[
                Text("📏 Jarak: ${jarak.toStringAsFixed(2)} km",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("🚶 Jalan kaki: ${estimasi["jalan"]}"),
                Text("🚴 Sepeda: ${estimasi["sepeda"]}"),
                Text("🏍 Motor: ${estimasi["motor"]}"),
                Text("🚗 Mobil: ${estimasi["mobil"]}"),
                Text("🚆 Kereta: ${estimasi["kereta"]}"),
              ] else
                Text("Lokasi Anda tidak ditemukan"),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text("Tutup"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps Destinasi"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-6.2000, 106.8166),
          zoom: 12,
        ),
        onMapCreated: (controller) =>
            _mapController = controller, // 🔥 digunakan
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
