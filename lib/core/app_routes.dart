import 'package:flutter/material.dart';

// import halaman
import '../pages/home_page.dart';
import '../pages/add_page.dart';
import '../pages/maps_page.dart';
import '../pages/detail_page.dart';
import '../pages/edit_page.dart';

// fitur baru
import '../pages/favorite_page.dart';
import '../pages/review_page.dart';

// model
import '../models/lokasi_model.dart';

class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/add':
        return MaterialPageRoute(builder: (_) => const AddPage());

      case '/maps':
        return MaterialPageRoute(builder: (_) => MapsPage());

      case '/detail':
        final args = settings.arguments;
        if (args is LokasiModel) {
          return MaterialPageRoute(builder: (_) => DetailPage(data: args));
        }
        return _errorRoute();

      case '/edit':
        final args = settings.arguments;
        if (args is LokasiModel) {
          return MaterialPageRoute(builder: (_) => EditPage(data: args));
        }
        return _errorRoute();

      // =======================================================
      // ⭐ FITUR BARU — FAVORITE
      // =======================================================
      case '/favorite':
        return MaterialPageRoute(
          builder: (_) => FavoritePage(),
        );

      // =======================================================
      // ⭐ FITUR BARU — REVIEW
      // =======================================================
      case '/review':
        return MaterialPageRoute(
          builder: (_) => ReviewPage(),
        );

      // =======================================================

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }

  // Route fallback kalau arguments salah
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text("Route Error / Arguments Tidak Sesuai")),
      ),
    );
  }
}
