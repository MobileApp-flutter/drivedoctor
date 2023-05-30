import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductController {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<ProductData>> getProducts() async {
    try {
      final QuerySnapshot snapshot = await productsCollection.get();

      return snapshot.docs.map((doc) => ProductData.fromSnapshot(doc)).toList();
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }

  Future<List<ProductData>> getProductsByShopId(String shopId) async {
    try {
      final QuerySnapshot snapshot = await productsCollection
          .where('shopId', isEqualTo: shopId)
          .get();

      return snapshot.docs.map((doc) => ProductData.fromSnapshot(doc)).toList();
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }

  Future<ProductData?> getProductById(String productId) async {
    try {
      final DocumentSnapshot snapshot =
          await productsCollection.doc(productId).get();

      if (snapshot.exists) {
        return ProductData.fromSnapshot(snapshot);
      } else {
        print('Product not found');
        return null;
      }
    } catch (error) {
      print('Error fetching product: $error');
      return null;
    }
  }
}
