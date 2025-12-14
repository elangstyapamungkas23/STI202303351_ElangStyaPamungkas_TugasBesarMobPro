class ReviewModel {
  final String name;
  final String comment;
  final int rating;

  // ⭐ Tambahan baru → nama tempat (optional)
  final String? placeName;

  ReviewModel({
    required this.name,
    required this.comment,
    required this.rating,
    this.placeName, // dibuat optional supaya kode lama tidak error
  });
}
