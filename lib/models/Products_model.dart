import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id; // Firestore document ID (auto-generated)
  String productTitle;
  double productPrice;
  int productStock;
  String productDescription;
  String? imageUrl;

  Product({
    required this.id,
    required this.productTitle,
    required this.productPrice,
    required this.productStock,
    required this.productDescription,
    this.imageUrl,
  });

 

  // Normal Map (JSON) se Product object banaye
  factory Product.fromMap(Map<String, dynamic> data, {String? id}) {
    return Product(
      id: id ?? '', // agar ID nahi mili to empty string
      productTitle: data['product_title'] ?? '',
      productPrice: (data['product_price'] ?? 0).toDouble(),
      productStock: (data['product_stock'] ?? 0).toInt(),
      productDescription: data['product_description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Product object ko Map (JSON) me convert kare
  Map<String, dynamic> toMap() {
    return {
      'product_title': productTitle,
      'product_price': productPrice,
      'product_stock': productStock,
      'product_description': productDescription,
      'imageUrl': imageUrl,
    };
  }
}
