import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ServicesService {
  static Stream<ServiceData?> get shopDataStream {
    final shopDoc = FirebaseFirestore.instance
        .collection('services')
        .doc(Auth.currentUser!.uid);
    return shopDoc.snapshots().map((snapshot) =>
        snapshot.exists ? ServiceData.fromSnapshot(snapshot) : null);
  }
}

//create shop
Future createService({
  required String servicename,
  required String serviceprice,
  required String waittime,
}) async {
  final serviceDoc = FirebaseFirestore.instance.collection('services').doc();
  final shopId = serviceDoc.id;

  final serviceData = {
    'servicename': servicename,
    'serviceprice': serviceprice,
    'waittime': waittime,
  };

  await serviceDoc.set(serviceData);

  // update user's shop ID
  final userQuerySnapshot = await FirebaseFirestore.instance
      .collection('services')
      .where('email', isEqualTo: Auth.email)
      .get();
  if (userQuerySnapshot.docs.isNotEmpty) {
    final userDoc = userQuerySnapshot.docs.first.reference;
    await userDoc.update({'shopId': shopId});
  } else {
    logger.e('User not found.');
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
