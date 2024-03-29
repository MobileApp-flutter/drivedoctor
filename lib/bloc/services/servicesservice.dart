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

//create service
Future createService({
  required String serviceId,
  required String servicename,
  required String serviceprice,
  required String waittime,
  required String servicedesc,
  required String shopId, //add the shopId parameter
}) async {
  final serviceDoc =
      FirebaseFirestore.instance.collection('services').doc(serviceId);

  final serviceData = {
    'serviceId': serviceId,
    'servicename': servicename,
    'serviceprice': serviceprice,
    'waittime': waittime,
    'servicedesc': servicedesc,
    'shopId': shopId, //add the shopId field
  };

  await serviceDoc.set(serviceData);
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

//update user
Future<void> updateService({
  String? serviceId,
  String? servicename,
  String? serviceprice,
  String? waittime,
  String? servicedesc,
}) async {
  final collection = FirebaseFirestore.instance.collection('services');
  final documentRef = collection.doc(serviceId);

  final dataToUpdate = <String, dynamic>{};

  if (servicename != null && servicename.isNotEmpty) {
    dataToUpdate['servicename'] = servicename;
  }

  if (serviceprice != null && serviceprice.isNotEmpty) {
    dataToUpdate['serviceprice'] = serviceprice;
  }

  if (waittime != null && waittime.isNotEmpty) {
    dataToUpdate['waittime'] = waittime;
  }

  if (servicedesc != null && servicedesc.isNotEmpty) {
    dataToUpdate['servicedesc'] = servicedesc;
  }

  await documentRef.update(dataToUpdate);
}

Future<void> deleteService({
  String? serviceId,
  String? servicename,
  String? serviceprice,
  String? waittime,
  String? servicedesc,
}) async {
  final serviceDocRef =
      FirebaseFirestore.instance.collection('services').doc(serviceId);
  await serviceDocRef.delete();
}
