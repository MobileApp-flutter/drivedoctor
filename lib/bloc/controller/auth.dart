import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/order.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User? get currentUser => auth.currentUser;
  static String get email => currentUser?.email ?? 'Guest';
  static String get uid => currentUser?.uid ?? 'Guest';

  //get all user data
  static Future<List<UserData>> getUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection("users").get();
    final userData =
        userDoc.docs.map((doc) => UserData.fromSnapshot(doc)).toList();

    return userData;
  }

  //get user data by email
  static Future<UserData> getUserDataByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    final userData =
        userDoc.docs.map((doc) => UserData.fromSnapshot(doc)).single;

    return userData;
  }

  //get user data by user id
  static Future<UserData> getUserDataByUserId(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();
    final userData =
        userDoc.docs.map((doc) => UserData.fromSnapshot(doc)).single;

    return userData;
  }

  //get shopId
  static Future<String> getShopId(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    final String shopId = userDoc.docs.map((doc) => doc['shopId']).single;

    return shopId;
  }

  //get shop data by email
  static Future<ShopData> getShopDataByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("shops")
        .where("email", isEqualTo: email)
        .get();
    final shopData =
        userDoc.docs.map((doc) => ShopData.fromSnapshot(doc)).single;

    return shopData;
  }

  //get shop data by shopId
  static Future<ShopData> getShopDataByShopId(String shopId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("shops")
        .where("shopId", isEqualTo: shopId)
        .get();
    final shopData =
        userDoc.docs.map((doc) => ShopData.fromSnapshot(doc)).single;

    return shopData;
  }

  //get service data by serviceId
  static Future<ServiceData> getServiceDataByServiceId(String serviceId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("services")
        .where("serviceId", isEqualTo: serviceId)
        .get();
    final serviceData =
        userDoc.docs.map((doc) => ServiceData.fromSnapshot(doc)).single;

    return serviceData;
  }
}
