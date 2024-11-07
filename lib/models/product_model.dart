// lib/models/product_model.dart

class Product {
  final String barcode;
  final String name;
  final String description;
  final String price;
  final String image;

  Product({
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(String barcode, Map<String, dynamic> json) {
    return Product(
      barcode: barcode,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}