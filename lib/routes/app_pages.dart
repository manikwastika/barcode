// lib/routes/app_pages.dart

import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/scanner_view.dart';
import '../views/product_info_view.dart';
import '../views/manual_input_view.dart';
import '../bindings/app_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeView(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/scanner',
      page: () => ScannerView(),
    ),
    GetPage(
      name: '/product-info',
      page: () => ProductInfoView(),
    ),
    GetPage(
      name: '/manual-input',
      page: () => ManualInputView(),
    ),
  ];
}