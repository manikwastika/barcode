import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../routes/app_pages.dart';

class ScannerController extends GetxController
    with SingleGetTickerProviderMixin {
  final List<CameraDescription> cameras = Get.arguments;
  late CameraController cameraController;
  RxBool isInitialized = false.obs;
  RxBool isScanning = false.obs;
  RxBool isFlashOn = false.obs;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  Future<void> initializeCamera() async {
    final CameraDescription camera = cameras.first;
    cameraController = CameraController(camera, ResolutionPreset.medium);
    await cameraController.initialize();
    isInitialized.value = true;
    startScanning();
  }

  void startScanning() {
    if (cameraController.value.isInitialized) {
      isScanning.value = true;
      scanBarcodes();
    }
  }

  Future<void> scanBarcodes() async {
    if (!isScanning.value) return;

    try {
      final image = await cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

      final barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        Get.offNamed(Routes.PRODUCT_INFO, arguments: [barcodes[0].displayValue ?? '', cameras]);
      } else {
        Future.delayed(Duration(milliseconds: 500), scanBarcodes);
      }

      await barcodeScanner.close();
    } catch (e) {
      print('Error scanning barcode: $e');
      Future.delayed(Duration(milliseconds: 500), scanBarcodes);
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController.value.isInitialized) {
      isFlashOn.value = !isFlashOn.value;
      await cameraController.setFlashMode(
        isFlashOn.value ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        scanBarcodeFromImage(image.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> scanBarcodeFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

    try {
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        Get.offNamed(Routes.PRODUCT_INFO, arguments: [barcodes[0].displayValue ?? '', cameras]);
      } else {
        Get.dialog(_buildErrorDialog());
      }
    } catch (e) {
      print('Error scanning barcode: $e');
      Get.dialog(_buildErrorDialog());
    } finally {
      barcodeScanner.close();
    }
  }

  AlertDialog _buildErrorDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Barcode Salah",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            "Gambar barcode yang anda miliki salah, silahkan upload ulang barcode",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  @override
  void onClose() {
    isScanning.value = false;
    cameraController.dispose();
    animationController.dispose();
    super.onClose();
  }
}