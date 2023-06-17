import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:drivedoctor/bloc/models/feedback.dart';

class AllFeedbacksPage extends StatelessWidget {
  final List<FeedbackData> feedbacks;
  final Function updateFeedbacks;

  const AllFeedbacksPage({
    Key? key,
    required this.feedbacks,
    required this.updateFeedbacks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Feedbacks'),
      ),
      body: ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];

          return ListTile(
            title: Text(feedback.userEmail),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBarIndicator(
                  rating: feedback.rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(height: 4.0),
                Text(feedback.text),
              ],
            ),
          );
        },
      ),
    );
  }
}
