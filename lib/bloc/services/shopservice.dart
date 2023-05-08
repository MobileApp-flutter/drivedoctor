import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';

//create shop
Future createShop({
  required String shopname,
  required String companyname,
  required int companycontact,
  required String address,
  required String ownerId,
}) async {
  final shopDoc = FirebaseFirestore.instance.collection('shops').doc();
  final shopId = shopDoc.id;

  final shopData = {
    'name': shopname,
    'companyname': companyname,
    'companycontact': companycontact,
    'address': address,
    'ownerId': ownerId,
  };

  await shopDoc.set(shopData);

  //update user's shop ID
  final userDoc = FirebaseFirestore.instance.collection('users').doc(ownerId);
  await userDoc.update({'shopId': shopId});
}

//check shop exist
Future<bool> hasShopRegistered() async {
  final currentUser = Auth.currentUser;

  if (currentUser == null) {
    return false;
  }

  final shopQuerySnapshot = await FirebaseFirestore.instance
      .collection('shops')
      .where('ownerId', isEqualTo: currentUser.uid)
      .get();

  return shopQuerySnapshot.docs.isNotEmpty;
}
