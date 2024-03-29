import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/shop.dart';

class ProductData {
  final String productId; // Document ID generated by Firebase
  final String productName;
  final String description;
  final double price;
  final String shopId; // Reference to the shop's document ID
  String productStatus; // product status (for order product)
  double rating;
  int stock;
  int totalSold;
  int quantity; //quantity of how much customer buy the item
  ShopData? shop; // Add ShopData reference

  ProductData({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.shopId,
    this.productStatus = "pending",
    this.rating = 5,
    this.stock = 0,
    this.totalSold = 0,
    this.quantity = 0,
    this.shop, // Provide optional ShopData reference in the constructor
  });

  factory ProductData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ProductData(
      productId: snapshot.id, // Store the document ID as productId
      productName: data['productName'],
      description: data['description'] ?? "-",
      price: data['price'],
      shopId: data['shopId'],
      rating: data['rating'] ?? 5,
      stock: data['stock'] ?? 0,
      totalSold: data['totalSold'] ?? 0,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      'shopId': shopId,
      'rating': rating,
      'quantity': quantity,
      'productStatus': productStatus,
      // 'stock': stock,
      // 'totalSold': totalSold,
    };
  }

//fromJson
  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['productId'],
      productName: json['productName'],
      description: json['description'],
      price: json['price'],
      shopId: json['shopId'],
      rating: json['rating'],
      productStatus: json['productStatus'],
      // stock: json['stock'],
      // totalSold: json['totalSold'],
      quantity: json['quantity'] ??
          0, // Provide a default value if 'quantity' is null
    );
  }
}
