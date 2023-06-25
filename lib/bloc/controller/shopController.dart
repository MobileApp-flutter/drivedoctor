import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/shop.dart';

class ShopController {
  final CollectionReference shopsCollection =
      FirebaseFirestore.instance.collection('shops');

  Future<List<ShopData>> getShops() async {
    try {
      final QuerySnapshot snapshot = await shopsCollection.get();

      return snapshot.docs.map((doc) => ShopData.fromSnapshot(doc)).toList();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching shops: $error');
      }
      return [];
    }
  }

  Future<ShopData?> getShopById(String shopId) async {
    try {
      final DocumentSnapshot snapshot = await shopsCollection.doc(shopId).get();

      if (snapshot.exists) {
        return ShopData.fromSnapshot(snapshot);
      } else {
        if (kDebugMode) {
          print('Shop not found');
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching shop: $error');
      }
      return null;
    }
  }
}
