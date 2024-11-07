import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import 'app/routes/app_pages.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(GetMaterialApp(
    title: 'Barcode Scanner',
    initialRoute: Routes.HOME,
    getPages: AppPages.pages,
  ));
}