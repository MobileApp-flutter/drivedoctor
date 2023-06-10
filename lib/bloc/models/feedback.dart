import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackData {
  final String? id; // ID of the feedback
  final String shopId; // ID of the shop
  final String userId; // ID of the user providing the feedback
  final String text;
  final double rating;
  final DateTime dateTime;

  FeedbackData({
    this.id,
    required this.shopId,
    required this.userId,
    required this.text,
    required this.rating,
    required this.dateTime,
  });

  factory FeedbackData.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    final shopId = data['shopId'] as String?;
    final userId = data['userId'] as String?;
    final text = data['text'] as String?;
    final rating = (data['rating'] as num?)?.toDouble();
    final timestamp = data['dateTime'] as Timestamp?;

    if (shopId == null ||
        userId == null ||
        text == null ||
        rating == null ||
        timestamp == null) {
      throw Exception('Invalid feedback data');
    }

    return FeedbackData(
      id: snapshot.id, // Assign the document ID as the feedback ID
      shopId: shopId,
      userId: userId,
      text: text,
      rating: rating,
      dateTime: timestamp.toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopId': shopId,
      'userId': userId,
      'text': text,
      'rating': rating,
      'dateTime': Timestamp.fromDate(
          dateTime), // Convert DateTime to Firestore Timestamp when saving to Firestore
    };
  }
}
