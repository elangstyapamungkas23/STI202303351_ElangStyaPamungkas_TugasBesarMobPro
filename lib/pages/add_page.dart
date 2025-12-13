import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/get_current_location.dart';
import '../models/lokasi_model.dart';
import '../db/database_helper.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final namaC = TextEditingController();
  final deskC = TextEditingController();
  final alamatC = TextEditingController();
  final latC = TextEditingController();
  final lngC = TextEditingController();
  final tanggalC = TextEditingController();
  final waktuC = TextEditingController();

  List<File> fotoList = []; // <<=== MULTI FOTO
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _ambilLokasiOtomatis();
  }

  Future<void> _ambilLokasiOtomatis() async {
    try {
      final pos = await GetPosition.getPosition();
      setState(() {
        latC.text = pos.latitude.toStringAsFixed(6);
        lngC.text = pos.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      print("Lokasi gagal diambil: $e");
    }
  }

  // ================= FOTO DARI GALLERY =================
  Future<void> _ambilFotoGallery() async {
    if (fotoList.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Maksimal 5 foto")));
      return;
    }

    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        fotoList.add(File(file.path));
      });
    }
  }

  // ================= FOTO DARI KAMERA =================
  Future<void> _ambilFotoKamera() async {
    if (fotoList.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Maksimal 5 foto")));
      return;
    }

    final XFile? file = await picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      setState(() {
        fotoList.add(File(file.path));
      });
    }
  }

  Future<void> _pilihTanggal() async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (pilih != null) {
      tanggalC.text = "${pilih.day}-${pilih.month}-${pilih.year}";
    }
  }

  Future<void> _pilihWaktu() async {
    final pilih = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pilih != null) waktuC.text = pilih.format(context);
  }

  Future<void> _simpan() async {
    if (namaC.text.isEmpty || latC.text.isEmpty || lngC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi Nama, Latitude & Longitude!")),
      );
      return;
    }

    // Simpan hanya 1 foto pertama untuk DB (sesuai model kamu)
    final fotoUtama = fotoList.isNotEmpty ? fotoList.first.path : null;

    final data = LokasiModel(
      nama: namaC.text,
      deskripsi: deskC.text,
      alamat: alamatC.text,
      foto: fotoUtama,
      latitude: double.parse(latC.text.trim()),
      longitude: double.parse(lngC.text.trim()),
      tanggal: tanggalC.text,
      jamBuka: waktuC.text,
      jamTutup: "-",
    );

    await DatabaseHelper.instance.create(data);
    Navigator.pop(context);
  }

  // ============= INPUT BOX FIX =============
  Widget inputBox({
    required IconData icon,
    required String hint,
    required TextEditingController c,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: c,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true, signed: true)
            : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'[-0-9\.]'))]
            : [],
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
  // =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text("Tambah Destinasi"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ================= FOTO PREVIEW =================
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: fotoList.isEmpty
                ? const Center(child: Text("Belum ada foto"))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fotoList.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          fotoList[i],
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 12),

          // ==== TOMBOL KAMERA & GALLERY ====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _ambilFotoGallery,
                icon: const Icon(Icons.photo),
                label: const Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _ambilFotoKamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Kamera"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),

          const SizedBox(height: 20),

          inputBox(icon: Icons.location_on, hint: "Nama Destinasi", c: namaC),
          const SizedBox(height: 14),
          inputBox(
            icon: Icons.description,
            hint: "Deskripsi",
            c: deskC,
            maxLines: 3,
          ),
          const SizedBox(height: 14),
          inputBox(icon: Icons.map, hint: "Alamat / Lokasi", c: alamatC),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: inputBox(
                  icon: Icons.my_location,
                  hint: "Latitude",
                  c: latC,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: inputBox(
                  icon: Icons.explore,
                  hint: "Longitude",
                  c: lngC,
                  isNumber: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: inputBox(
                  icon: Icons.calendar_today,
                  hint: "Pilih Tanggal",
                  c: tanggalC,
                  readOnly: true,
                  onTap: _pilihTanggal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: inputBox(
                  icon: Icons.access_time,
                  hint: "Pilih Waktu",
                  c: waktuC,
                  readOnly: true,
                  onTap: _pilihWaktu,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ElevatedButton(
            onPressed: _simpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Simpan Destinasi",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
