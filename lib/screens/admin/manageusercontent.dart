import 'package:drivedoctor/screens/admin/manageuser.dart';
import 'package:drivedoctor/widgets/admin_side_menu.dart';
import 'package:flutter/material.dart';

class Manageusercontent extends StatefulWidget {
  const Manageusercontent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ManageusercontentState createState() => _ManageusercontentState();
}

class _ManageusercontentState extends State<Manageusercontent> {
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
            children: [
              GestureDetector(
                onTap: _toggleSidebar,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isSidebarOpen ? 250 : 60,
                  child: const SideMenu(),
                ),
              ),
              Expanded(
                flex: _isSidebarOpen ? 5 : 1,
                child: GestureDetector(
                  onTap: () {
                    if (_isSidebarOpen) {
                      _toggleSidebar();
                    }
                  },
                  child: const Manageuser(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
