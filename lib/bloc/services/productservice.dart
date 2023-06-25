import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProductsService {
  static Stream<ProductData?> get shopDataStream {
    final shopDoc = FirebaseFirestore.instance
        .collection('products')
        .doc(Auth.currentUser!.uid);
    return shopDoc.snapshots().map((snapshot) =>
        snapshot.exists ? ProductData.fromSnapshot(snapshot) : null);
  }
}

//create service
Future<void> createProduct({
  required String productId,
  required String productName,
  required double price,
  required String description,
  required int stock,
  required String shopId,
}) async {
  final productDoc =
      FirebaseFirestore.instance.collection('products').doc(productId);

  final productData = {
    'productId': productId,
    'productName': productName,
    'price': price,
    'description': description,
    'stock': stock,
    'shopId': shopId,
  };

  await productDoc.set(productData);
}

Future<ShopData?> hasShopRegistered(String email) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final shopDoc = await FirebaseFirestore.instance
      .collection('shops')
      .where('email', isEqualTo: email)
      .get();

  if (shopDoc.docs.isEmpty) return null;

  final shop = ShopData.fromSnapshot(shopDoc.docs.first);

  return shop;
}

// Update a product
Future<void> updateProduct({
  required String productId,
  String? productName,
  double? price,
  String? description,
  int? stock,
}) async {
  final documentRef =
      FirebaseFirestore.instance.collection('products').doc(productId);

  final dataToUpdate = <String, dynamic>{};

  if (productName != null && productName.isNotEmpty) {
    dataToUpdate['productName'] = productName;
  }

  if (price != null) {
    dataToUpdate['price'] = price;
  }

  if (description != null && description.isNotEmpty) {
    dataToUpdate['description'] = description;
  }

  if (stock != null) {
    dataToUpdate['stock'] = stock;
  }

  await documentRef.update(dataToUpdate);
}

// Delete a product
Future<void> deleteProduct(String productId) async {
  final productDocRef =
      FirebaseFirestore.instance.collection('products').doc(productId);
  await productDocRef.delete();
}
