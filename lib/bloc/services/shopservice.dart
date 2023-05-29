import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ShopService {
  static Stream<ShopData?> get shopDataStream {
    final shopDoc = FirebaseFirestore.instance
        .collection('shops')
        .doc(Auth.currentUser!.uid);
    return shopDoc.snapshots().map(
        (snapshot) => snapshot.exists ? ShopData.fromSnapshot(snapshot) : null);
  }
}

//create shop
Future createShop({
  required String shopname,
  required String companyname,
  required int companycontact,
  required String companyemail,
  required String address,
  required String email,
}) async {
  final shopDoc = FirebaseFirestore.instance.collection('shops').doc();
  final shopId = shopDoc.id;

  final shopData = {
    'shopname': shopname,
    'companyname': companyname,
    'companycontact': companycontact,
    'companyemail': companyemail,
    'address': address,
    'email': email,
  };

  await shopDoc.set(shopData);

  // update user's shop ID
  final userQuerySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  if (userQuerySnapshot.docs.isNotEmpty) {
    final userDoc = userQuerySnapshot.docs.first.reference;
    await userDoc.update({'shopId': shopId});
  } else {
    logger.e('User with username $email not found.');
  }
}

//check shop exist
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
