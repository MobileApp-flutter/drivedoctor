import 'package:drivedoctor/widgets/admin_header.dart';
import 'package:drivedoctor/widgets/admin_side_menu.dart';
import 'package:flutter/material.dart';

class Admincontent extends StatelessWidget {
  const Admincontent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            backgroundColor: Colors.blue.shade800,
          ),
          drawer: const Drawer(
            child:
                AdminSideMenu(), // Replace SideMenu with your actual drawer content
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 20),
                Header(),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "This is where admin manages the user",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
