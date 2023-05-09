import 'package:cloud_firestore/cloud_firestore.dart';

class ShopData {
  final String shopname;
  final String companyname;
  final int companycontact;
  final String address;
  final String owneremail;

  ShopData({
    required this.shopname,
    required this.companyname,
    required this.companycontact,
    required this.address,
    required this.owneremail,
  });

  factory ShopData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ShopData(
      shopname: data['shopname'],
      companyname: data['companyname'],
      companycontact: data['companycontact'],
      address: data['address'],
      owneremail: data['email'],
    );
  }
}
