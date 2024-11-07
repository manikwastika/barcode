import 'package:get/get.dart';

import '../controllers/manual_input_controller.dart';

class ManualInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualInputController>(
      () => ManualInputController(),
    );
  }
}