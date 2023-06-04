import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:flutter/material.dart';

class ShopSideMenu extends StatelessWidget {
  const ShopSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // UserAccountsDrawerHeader(
        //   // accountName: const Text(
        //   //   'Shop',
        //   //   style: TextStyle(color: Colors.black),
        //   // ),
        //   // accountEmail: Text(
        //   //   Auth.email,
        //   //   style: const TextStyle(color: Colors.black),
        //   // ),
        //   // currentAccountPicture: CircleAvatar(
        //   //   child: ClipOval(
        //   //     child: Image.asset(
        //   //       'assets/logo_white.png',
        //   //       width: 90,
        //   //       height: 90,
        //   //       fit: BoxFit.cover,
        //   //     ),
        //   //   ),
        //   // ),
        //   decoration: const BoxDecoration(
        //     color: Colors.blue,
        //     image: DecorationImage(
        //       image: AssetImage('assets/background.jpeg'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        ListTile(
          title: const Text("Dashboard", style: TextStyle(color: Colors.black)),
          leading: const Icon(Icons.dashboard, color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, shopDashboard);
          },
        ),
        ListTile(
          title: const Text("User Dashboard",
              style: TextStyle(color: Colors.black)),
          leading: const Icon(Icons.person_2, color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, profile);
          },
        ),
        ListTile(
          title:
              const Text("Manage shop", style: TextStyle(color: Colors.black)),
          leading: const Icon(Icons.shopify, color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, shopProfile);
          },
        ),
        ListTile(
          title: const Text("Manage service",
              style: TextStyle(color: Colors.black)),
          leading: const Icon(Icons.home_repair_service, color: Colors.black),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Manage product",
              style: TextStyle(color: Colors.black)),
          leading:
              const Icon(Icons.production_quantity_limits, color: Colors.black),
          onTap: () {},
        ),
      ],
    ));
  }
}
