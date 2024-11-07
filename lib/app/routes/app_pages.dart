import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../bindings/manual_input_binding.dart';
import '../bindings/product_info_binding.dart';
import '../bindings/scanner_binding.dart';
import '../views/home_view.dart';
import '../views/manual_input_view.dart';
import '../views/product_info_view.dart';
import '../views/scanner_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SCANNER,
      page: () => ScannerView(),
      binding: ScannerBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_INFO,
      page: () => ProductInfoView(),
      binding: ProductInfoBinding(),
    ),
    GetPage(
      name: Routes.MANUAL_INPUT,
      page: () => ManualInputView(),
      binding: ManualInputBinding(),
    ),
  ];

  static var pages;
}