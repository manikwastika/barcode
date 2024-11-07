import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/product_info_controller.dart';

class ProductInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductInfoController>(
      () => ProductInfoController(),
    );
  }
}