import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/authservice.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.blue.shade900,
      ), // Set the desired background color
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(child: Image.asset('assets/logo_white.png')),
              ListTile(
                title: const Text("Dashboard",
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.dashboard, color: Colors.white),
                onTap: () {
                  Navigator.pushReplacementNamed(context, adminDashboard);
                },
              ),
              ListTile(
                title: const Text("User Management",
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.person_4, color: Colors.white),
                onTap: () {
                  Navigator.pushReplacementNamed(context, manageUser);
                },
              ),
              ListTile(
                title: const Text("Subscription Management",
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.subscriptions, color: Colors.white),
                onTap: () {},
              ),
              ListTile(
                title:
                    const Text("Logout", style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.logout, color: Colors.white),
                onTap: () async {
                  await signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
