import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/lokasi_model.dart';
import '../db/database_helper.dart';

class EditPage extends StatefulWidget {
  final LokasiModel data;

  const EditPage({super.key, required this.data});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final namaC = TextEditingController();
  final deskC = TextEditingController();
  final alamatC = TextEditingController();
  final latC = TextEditingController();
  final lngC = TextEditingController();
  final tanggalC = TextEditingController();
  final waktuC = TextEditingController();

  File? foto;

  @override
  void initState() {
    super.initState();

    // isi form dengan data lama
    namaC.text = widget.data.nama;
    deskC.text = widget.data.deskripsi ?? "";
    alamatC.text = widget.data.alamat ?? "";
    latC.text = widget.data.latitude.toString();
    lngC.text = widget.data.longitude.toString();
    tanggalC.text = widget.data.tanggal ?? "";
    waktuC.text = widget.data.jamBuka ?? "";

    if (widget.data.foto != null) {
      foto = File(widget.data.foto!);
    }
  }

  Future<void> _ambilFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() => foto = File(file.path));
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

  Future<void> _update() async {
    final updated = LokasiModel(
      id: widget.data.id, // penting agar update bekerja
      nama: namaC.text,
      deskripsi: deskC.text,
      alamat: alamatC.text,
      foto: foto?.path,
      latitude: double.parse(latC.text),
      longitude: double.parse(lngC.text),
      tanggal: tanggalC.text,
      jamBuka: waktuC.text,
      jamTutup: widget.data.jamTutup,
    );

    await DatabaseHelper.instance.update(updated);
    Navigator.pop(context);
  }

  Widget inputBox({
    required IconData icon,
    required String hint,
    required TextEditingController c,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
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
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text("Edit Destinasi"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: _ambilFoto,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: foto == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text("Tambah Foto/Video Destinasi"),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(foto!, fit: BoxFit.cover),
                    ),
            ),
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
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: inputBox(
                  icon: Icons.explore,
                  hint: "Longitude",
                  c: lngC,
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
            onPressed: _update,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Update Destinasi",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
