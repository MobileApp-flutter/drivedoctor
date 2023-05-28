import 'package:drivedoctor/widgets/admin_header.dart';
import 'package:flutter/material.dart';

class Admincontent extends StatelessWidget {
  const Admincontent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: const [
            SizedBox(height: 20),
            Header(),
            SizedBox(height: 40), // Add some vertical spacing
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      16), // Add horizontal padding to align text to the left
              child: Text(
                "This is where admin manage the user",
                style: TextStyle(fontSize: 18), // Set the desired font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
