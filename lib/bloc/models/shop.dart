import 'package:cloud_firestore/cloud_firestore.dart';

import 'feedback.dart';

class ShopData {
  final String shopId; // Add shopId property
  final String shopname;
  final String companyname;
  final String companycontact;
  final String companyemail;
  final String address;
  final String owneremail;
  String imageUrl;
  double rating;
  List<FeedbackData> feedbacks;

  ShopData({
    required this.shopId,
    required this.shopname,
    required this.companyname,
    required this.companycontact,
    required this.companyemail,
    required this.address,
    required this.owneremail,
    required this.imageUrl,
    required this.rating,
    this.feedbacks = const [],
  });

  factory ShopData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ShopData(
      shopId: snapshot.id, // Assign the document ID as the shopId
      shopname: data['shopname'],
      companyname: data['companyname'],
      companycontact: data['companycontact'],
      companyemail: data['companyemail'],
      address: data['address'],
      owneremail: data['email'],
      imageUrl: data['imageUrl'] ??
          "https://images.unsplash.com/photo-1615906655593-ad0386982a0f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
      rating: data['rating'] ?? 5,
    );
  }
}
