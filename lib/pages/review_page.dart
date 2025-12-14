import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_controller.dart';
import '../models/review_model.dart';

class ReviewPage extends StatelessWidget {
  final ReviewController reviewC = Get.find();

  final nameC = TextEditingController();
  final commentC = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Pengunjung"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (reviewC.reviews.isEmpty) {
                return const Center(
                  child: Text("Belum ada review"),
                );
              }

              return ListView.builder(
                itemCount: reviewC.reviews.length,
                itemBuilder: (context, index) {
                  final data = reviewC.reviews[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text("${data.name} ⭐${data.rating}"),
                      subtitle: Text(data.comment),
                    ),
                  );
                },
              );
            }),
          ),

          // FORM INPUT
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                  ),
                ),
                TextField(
                  controller: commentC,
                  decoration: const InputDecoration(
                    labelText: "Komentar",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      onPressed: () {
                        rating = i + 1;
                      },
                      icon: Icon(Icons.star,
                          color: i < rating ? Colors.amber : Colors.grey),
                    );
                  }),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (nameC.text.isNotEmpty && commentC.text.isNotEmpty) {
                      reviewC.addReview(
                        ReviewModel(
                          name: nameC.text,
                          comment: commentC.text,
                          rating: rating,
                        ),
                      );
                      nameC.clear();
                      commentC.clear();
                      rating = 0;
                    }
                  },
                  child: const Text("Kirim Review"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
