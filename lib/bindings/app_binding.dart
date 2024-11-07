// lib/bindings/app_binding.dart

import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';
import '../controllers/product_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
    Get.put(ScannerController());
  }
}