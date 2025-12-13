import 'dart:io';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/lokasi_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LokasiModel> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.readAll();
    setState(() => dataList = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text(
          "Destinasi Saya",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: dataList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada destinasi.\nTambahkan sekarang!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dataList.length,
              itemBuilder: (context, i) {
                final d = dataList[i];
                return _destinationCard(d);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.pushNamed(context, "/add");
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ========================= CARD DESTINASI =========================
  Widget _destinationCard(LokasiModel d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO + TITIK TIGA (EDIT/HAPUS)
          Stack(
            children: [
              // FOTO
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/detail", arguments: d);
                  },
                  child: d.foto == null
                      ? Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Center(child: Text("Tidak ada foto")),
                        )
                      : Image.file(
                          File(d.foto!),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              // =========== TITIK TIGA EDIT/HAPUS =============
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) async {
                      if (value == "edit") {
                        await Navigator.pushNamed(
                          context,
                          "/edit",
                          arguments: d, // <-- kirim data ke EditPage
                        );
                        _loadData(); // refresh setelah kembali
                      }

                      if (value == "delete") {
                        await DatabaseHelper.instance.delete(d.id!);
                        _loadData(); // refresh setelah hapus
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 6),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 6),
                            Text("Hapus", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ======== INFORMASI DESTINASI ========
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Lokasi: ${d.latitude.toStringAsFixed(4)}°, ${d.longitude.toStringAsFixed(4)}°",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // NAMA
                Text(
                  d.nama,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                // ALAMAT
                Text(
                  d.alamat ?? "-",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),

                // KOORDINAT
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(d.latitude.toStringAsFixed(4)),
                    const SizedBox(width: 14),
                    const Icon(Icons.location_searching, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(d.longitude.toStringAsFixed(4)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
