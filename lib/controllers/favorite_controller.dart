import 'package:get/get.dart';
import '../models/favorite_model.dart';

class FavoriteController extends GetxController {
  RxList<FavoriteModel> favorites = <FavoriteModel>[].obs;

  void toggleFavorite(FavoriteModel item) {
    if (favorites.any((f) => f.title == item.title)) {
      favorites.removeWhere((f) => f.title == item.title);
    } else {
      favorites.add(item);
    }
  }

  bool isFavorite(String title) {
    return favorites.any((f) => f.title == title);
  }
}
