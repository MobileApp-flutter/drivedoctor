import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import '../../bloc/models/shop.dart';

class FeedbackPage extends StatefulWidget {
  final ShopData shop;

  FeedbackPage({required this.shop});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0.0;
  String feedback = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  feedback = value;
                });
              },
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your feedback...',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the feedback to Firestore
                FirebaseFirestore.instance
                    .collection('feedbacks')
                    .add({
                  'shopId': widget.shop.shopId,
                  'text': feedback,
                  'rating': rating,
                });

                // Navigate back to the shop dashboard
                Navigator.pop(context);
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
