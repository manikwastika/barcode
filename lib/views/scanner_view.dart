import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';
import '../widgets/scanner_overlay.dart';

class ScannerView extends GetView<ScannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.isInitialized.value
            ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CameraPreview(controller.cameraController),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.2,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.7,
                              child: CustomPaint(
                                painter: ScannerOverlay(
                                  animation: controller.animation,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: Obx(() => Icon(
                                  controller.isFlashOn.value
                                      ? Icons.flash_on
                                      : Icons.flash_off,
                                  color: Colors.white,
                                )),
                            onPressed: controller.toggleFlash,
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildButton(
                                    'Scan Image',
                                    controller.pickImage,
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    width: 1,
                                    color: Colors.grey,
                                    height: 40,
                                  ),
                                  SizedBox(width: 15),
                                  _buildButton(
                                    'Manually',
                                    () => Get.toNamed('/manual-input'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 130,
      height: 50,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}