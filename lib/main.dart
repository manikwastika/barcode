import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'routes/app_pages.dart';
import 'controllers/product_controller.dart';
import 'controllers/scanner_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  // Register the controllers
  Get.put(ProductController());
  Get.lazyPut(() => ScannerController());

  runApp(MyApp(cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp(this.cameras);

  @override
  Widget build(BuildContext context) {
    Get.put(ScannerController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
