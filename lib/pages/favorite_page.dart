import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteController favC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Destinasi"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (favC.favorites.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada yang difavoritkan",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: favC.favorites.length,
          itemBuilder: (context, index) {
            final data = favC.favorites[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: _buildImage(data.image), // ← DIUBAH SEDIKIT
                title: Text(data.title),
                subtitle: Text(data.description),
              ),
            );
          },
        );
      }),
    );
  }

  // ========= FIX TAMPILAN GAMBAR FAVORITE =========
  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    final file = File(path);

    if (!file.existsSync()) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image),
      );
    }

    return Image.file(file, width: 60, height: 60, fit: BoxFit.cover);
  }
}
