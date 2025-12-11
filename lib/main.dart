import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_routes.dart';
import 'controllers/review_controller.dart';
import 'controllers/favorite_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Register controller sebelum aplikasi jalan
  Get.put(ReviewController());
  Get.put(FavoriteController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel Wisata Lokal",
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generate,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Inter",
        colorSchemeSeed: Colors.blue,
      ),
    );
  }
}
