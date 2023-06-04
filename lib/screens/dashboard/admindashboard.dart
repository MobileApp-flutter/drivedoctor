import 'package:drivedoctor/screens/admin/admincontent.dart';
import 'package:flutter/material.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({Key? key}) : super(key: key);

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  bool _isSidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(), // Set the desired dark blue background color
      child: Scaffold(
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Admincontent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
