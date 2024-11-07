import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class ManualInputController extends GetxController {
  final List<dynamic> arguments = Get.arguments;
  final cameras = Get.arguments[0];
  final TextEditingController barcodeController = TextEditingController();

  void submitBarcode() {
    String barcode = barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      // Check if the barcode exists in the product data
      final productData = {
        '1234567890123': {},
        '4567890123456': {},
        '6001234567899': {},
        '4820000849463': {},
      };
      if (productData.containsKey(barcode)) {
        Get.offNamed(Routes.PRODUCT_INFO, arguments: [barcode, cameras]);
      } else {
        Get.dialog(_buildErrorDialog());
      }
    } else {
      Get.snackbar('Error', 'Please enter a valid barcode');
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
            "Angka Barcode yang anda masukan salah, silahkan coba lagi",
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
    barcodeController.dispose();
    super.onClose();
  }
}