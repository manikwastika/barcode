import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../controllers/scanner_controller.dart';
import '../routes/app_pages.dart';
import '../../widgets/scanner_overlay_painter.dart';

class ScannerView extends GetView<ScannerController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME, arguments: controller.cameras);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan Barcode'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(Routes.HOME, arguments: controller.cameras),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Obx(() => controller.isInitialized.value ? CameraPreview(controller.cameraController) : Container()),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        child: CustomPaint(
                          painter: ScannerOverlayPainter(animation: controller.animation),
                        ),  
                      ),
                    ),  
                  ),
                  Positioned(  
                    top: 16,
                    right: 16,
                    child: Obx(() => IconButton(
                      icon: Icon(
                        controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,  
                      ),
                      onPressed: () => controller.toggleFlash(),
                    )),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 0, 
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            Container(
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
                                    onPressed: () => controller.pickImage(),
                                    child: Text('Scan Image'),
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
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 1,
                              color: Colors.grey,
                              height: 40,
                            ), 
                            SizedBox(width: 15),
                            Container(
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
                                    onPressed: () => Get.toNamed(Routes.MANUAL_INPUT, arguments: controller.cameras),
                                    child: Text('Manually'),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),  
          ],
        ),
      ),
    );
  }
}