import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import './product_controller.dart';

class ScannerController extends GetxController with GetSingleTickerProviderStateMixin {
  final ProductController productController = Get.find<ProductController>();
  
  // Camera variables
  late CameraController cameraController;
  var cameras = <CameraDescription>[].obs;
  var isInitialized = false.obs;
  var isScanning = false.obs;
  var isFlashOn = false.obs;

  // Animation variables
  late AnimationController animationController;
  late Animation<double> animation;

  get lastScannedCode => null;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimation();
    initializeCamera();
  }

  void _initializeAnimation() {
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  Future<void> initializeCamera() async {
    try {
      if (!isInitialized.value) {
        cameras.value = await availableCameras();
        if (cameras.isNotEmpty) {
          cameraController = CameraController(
            cameras[0],
            ResolutionPreset.medium,
          );
          await cameraController.initialize();
          isInitialized.value = true;
          startScanning();
        }
      } else {
        startScanning();
      }
    } catch (e) {
      print('Error initializing camera: $e');
      // Coba initialize ulang jika gagal
      isInitialized.value = false;
      Future.delayed(Duration(milliseconds: 500), initializeCamera);
    }
  }

  void startScanning() {
    if (isInitialized.value && !isScanning.value) {
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
        String barcode = barcodes[0].displayValue ?? '';
        if (productController.isValidBarcode(barcode)) {
          productController.findProductByBarcode(barcode);
          await Get.toNamed('/product-info');
          // Reset scanning state setelah kembali
          isScanning.value = false;
          startScanning();
        } else {
          Get.snackbar(
            'Error',
            'Barcode tidak ditemukan',
            snackPosition: SnackPosition.BOTTOM,
          );
          if (isScanning.value) {
            Future.delayed(Duration(milliseconds: 500), scanBarcodes);
          }
        }
      } else {
        if (isScanning.value) {
          Future.delayed(Duration(milliseconds: 500), scanBarcodes);
        }
      }

      await barcodeScanner.close();
    } catch (e) {
      print('Error scanning barcode: $e');
      if (isScanning.value) {
        Future.delayed(Duration(milliseconds: 500), scanBarcodes);
      }
    }
  }

  Future<void> toggleFlash() async {
    try {
      if (isInitialized.value) {
        if (isFlashOn.value) {
          await cameraController.setFlashMode(FlashMode.off);
        } else {
          await cameraController.setFlashMode(FlashMode.torch);
        }
        isFlashOn.value = !isFlashOn.value;
      }
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await scanBarcodeFromImage(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> scanBarcodeFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

    try {
      final barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        String barcode = barcodes[0].displayValue ?? '';
        if (productController.isValidBarcode(barcode)) {
          productController.findProductByBarcode(barcode);
          await Get.toNamed('/product-info');
          // Reset dan mulai scanning setelah kembali
          isScanning.value = false;
          startScanning();
        } else {
          showErrorDialog();
          startScanning();
        }
      } else {
        showErrorDialog();
        startScanning();
      }
    } catch (e) {
      print('Error scanning barcode: $e');
      showErrorDialog();
      startScanning();
    } finally {
      barcodeScanner.close();
    }
  }

  void showErrorDialog() {
    Get.dialog(
      AlertDialog(
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
                startScanning();
              },
            ),
          ),
        ],
      ),
    );
  }

  void resetAndStartScanning() {
    isScanning.value = false;
    startScanning();
  }

  @override
  void onClose() {
    isScanning.value = false;
    if (isInitialized.value) {
      cameraController.dispose();
      isInitialized.value = false;
    }
    animationController.dispose();
    super.onClose();
  }
}