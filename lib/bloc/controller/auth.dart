import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User? get currentUser => auth.currentUser;
  static String get email => currentUser?.email ?? 'Guest';

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

  static Future<ShopData> getShopDataByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("shops")
        .where("email", isEqualTo: email)
        .get();
    final shopData =
        userDoc.docs.map((doc) => ShopData.fromSnapshot(doc)).single;

    return shopData;
  }
}
