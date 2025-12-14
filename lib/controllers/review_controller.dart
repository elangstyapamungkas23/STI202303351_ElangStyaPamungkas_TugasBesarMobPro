import 'package:get/get.dart';
import '../models/review_model.dart';

class ReviewController extends GetxController {
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  void addReview(ReviewModel review) {
    reviews.add(review);
  }

  // ⭐ FITUR BARU → ambil review berdasarkan nama lokasi
  List<ReviewModel> getReviewByPlace(String placeName) {
    return reviews.where((e) => e.placeName == placeName).toList();
  }

  // ⭐ FITUR BARU → hitung rata-rata rating lokasi
  double getAverageRating(String placeName) {
    final data = getReviewByPlace(placeName);
    if (data.isEmpty) return 0;

    final total = data.fold(0.0, (sum, item) => sum + item.rating);
    return total / data.length;
  }
}
