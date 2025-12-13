import 'dart:io';
import 'package:flutter/material.dart';
import '../models/lokasi_model.dart';

class DestinationCard extends StatelessWidget {
  final LokasiModel data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DestinationCard({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // FOTO
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade300,
              child: data.foto == null
                  ? const Icon(Icons.photo, size: 32, color: Colors.grey)
                  : Image.file(File(data.foto!), fit: BoxFit.cover),
            ),
          ),

          const SizedBox(width: 14),

          // INFO DESTINASI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                if (data.alamat != null && data.alamat!.isNotEmpty)
                  Text(
                    data.alamat!,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                const SizedBox(height: 4),
                Text(
                  "(${data.latitude.toStringAsFixed(4)}, ${data.longitude.toStringAsFixed(4)})",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // POPUP MENU
          PopupMenuButton(
            onSelected: (value) {
              if (value == "edit") onEdit();
              if (value == "delete") onDelete();
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
                    Icon(Icons.delete, size: 18),
                    SizedBox(width: 6),
                    Text("Hapus"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
