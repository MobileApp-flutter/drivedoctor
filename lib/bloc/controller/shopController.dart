import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop.dart';

class ShopController {
  final CollectionReference shopsCollection =
      FirebaseFirestore.instance.collection('shops');

  Future<List<ShopData>> getShops() async {
    final shopDoc = await FirebaseFirestore.instance.collection("shops").get();
    final shopData =
        shopDoc.docs.map((doc) => ShopData.fromSnapshot(doc)).toList();

    return shopData;
    // try {
    //   final QuerySnapshot snapshot = await shopsCollection.get();

    //   return snapshot.docs.map((doc) => ShopData.fromSnapshot(doc)).toList();
    // } catch (error) {
    //   print('Error fetching shops: $error');
    //   return [];
    // }
  }

  Future<ShopData?> getShopById(String shopId) async {
    try {
      final DocumentSnapshot snapshot = await shopsCollection.doc(shopId).get();

      if (snapshot.exists) {
        return ShopData.fromSnapshot(snapshot);
      } else {
        print('Shop not found');
        return null;
      }
    } catch (error) {
      print('Error fetching shop: $error');
      return null;
    }
  }
}
