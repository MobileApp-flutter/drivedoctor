import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/shop.dart';

class ProductData {
  final String productName;
  final String description;
  final double price;
  final String imageUrl;
  final String shopId; // Reference to the shop's document ID
  double rating;
  int stock;
  int totalSold;
  ShopData? shop; // Add ShopData reference

  ProductData({
    required this.productName,
    this.description = "-",
    required this.price,
    required this.imageUrl,
    required this.shopId,
    this.rating = 5,
    this.stock = 0,
    this.totalSold = 0,
    this.shop, // Provide optional ShopData reference in the constructor
  });

  factory ProductData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ProductData(
      productName: data['productName'],
      description: data['description'] ?? "-",
      price: data['price'],
      imageUrl: data['imageUrl'],
      shopId: data['shopId'],
      rating: data['rating'] ?? 5,
      stock: data['stock'] ?? 0,
      totalSold: data['totalSold'] ?? 0,
    );
  }
}
