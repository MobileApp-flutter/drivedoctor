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
  required String companycontact,
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

//update shop
Future<void> updateShop({
  // String? shopId,
  String? shopname,
  String? companyname,
  String? companycontact,
  String? companyemail,
  String? address,
  String? owneremail,
}) async {
  final docShop = FirebaseFirestore.instance
      .collection('shops')
      .where('email', isEqualTo: owneremail);

  final dataToUpdate = <String, dynamic>{};

  if (shopname != null && shopname.isNotEmpty) {
    dataToUpdate['shopname'] = shopname;
  }
  if (companyname != null && companyname.isNotEmpty) {
    dataToUpdate['companyname'] = companyname;
  }
  if (companycontact != null && companycontact.isNotEmpty) {
    dataToUpdate['companycontact'] = companycontact;
  }
  if (companyemail != null && companyemail.isNotEmpty) {
    dataToUpdate['companyemail'] = companyemail;
  }
  if (address != null && address.isNotEmpty) dataToUpdate['address'] = address;
  // if (dataToUpdate.isEmpty) return;

  await docShop.get().then((querySnapshot) async {
    final documentSnapshot = querySnapshot.docs.first;
    await documentSnapshot.reference.update(dataToUpdate);
  });
}
