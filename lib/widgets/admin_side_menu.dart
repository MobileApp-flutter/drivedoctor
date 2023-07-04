import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/authservice.dart';
import 'package:flutter/material.dart';

import '../screens/admin/subscription_management_page.dart';

class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: const Text(
            'Admin',
            style: TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            Auth.email,
            style: const TextStyle(color: Colors.black),
          ),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset(
                'assets/logo_white.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage('assets/background.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
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
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SubscriptionManagementPage()),
            );
          },
        ),
        ListTile(
          title: const Text("Logout", style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.logout, color: Colors.white),
          onTap: () async {
            await signOut(context);
          },
        ),
      ],
    ));
  }
}
