// lib/views/product_info_view.dart

import 'package:barcodeapp/controllers/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class ProductInfoView extends GetView<ProductController> {
  const ProductInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/');
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      final product = controller.currentProduct.value;
                      
                      if (product == null) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 80,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Barcode yang anda scan tidak ditemukan, pastikan kondisi barcode bersih dan tidak rusak ataupun tercoret',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.network(
                                  product.image,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RedHatText',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.7),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Hapus instance lama dari ScannerController
                    Get.delete<ScannerController>();
                    // Membuat instance baru menggunakan lazyPut
                    Get.lazyPut(() => ScannerController());
                    // Navigasi ke halaman scanner
                    Get.offAllNamed('/scanner');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Scan Barcode Lagi'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}