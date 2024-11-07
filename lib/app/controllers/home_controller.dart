import 'package:get/get.dart';

import '../../main.dart';
import '../routes/app_pages.dart';

class HomeController extends GetxController {

  void startScanner() {
    Get.toNamed(Routes.SCANNER, arguments: cameras);
  }
}