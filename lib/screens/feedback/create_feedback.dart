import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/user_service.dart';

class CreateFeedbackPage extends StatefulWidget {
  final String shopId;
  final String userId;
  final Function updateFeedbacks;

  const CreateFeedbackPage({
    required this.shopId,
    required this.userId,
    required this.updateFeedbacks,
  });

  @override
  _CreateFeedbackPageState createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends State<CreateFeedbackPage> {
  double _rating = 0.0;
  TextEditingController _feedbackController = TextEditingController();
  late String _username; // Add a variable to store the username

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch the user data when the widget initializes
  }

  void _loadUserData() async {
    try {
      final userService = UserService();
      final user = await userService.getUserDataById(widget.userId);

      if (user != null) {
        setState(() {
          _username = user.username;
        });
      } else {
        setState(() {
          _username = 'Unknown User';
        });
      }
    } catch (e) {
      setState(() {
        _username = 'Unknown User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;
    final userEmail = userProvider.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            RatingBar.builder(
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: 30.0,
              direction: Axis.horizontal,
              unratedColor: Colors.grey[300],
              allowHalfRating: false,
              initialRating: _rating,
            ),
            SizedBox(height: 16.0),
            Text(
              'Feedback',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final feedback = FeedbackData(
                  rating: _rating,
                  text: _feedbackController.text,
                  shopId: widget.shopId,
                  userId: Auth.uid,
                  userEmail: Auth.email,
                  dateTime: DateTime.now(),
                );

                await FirebaseFirestore.instance
                    .collection('feedbacks')
                    .add(feedback.toMap());

                // Call the callback function to update the feedback list
                widget.updateFeedbacks();

                Navigator.pop(context); // Return to the previous screen
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
