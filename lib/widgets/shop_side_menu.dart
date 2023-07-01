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
        ListTile(
          title: const Text("Manage order service",
              style: TextStyle(color: Colors.black)),
          leading:
              const Icon(Icons.local_shipping_outlined, color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, manageOrder);
          },
        ),
        ListTile(
          title: const Text("Manage order product",
              style: TextStyle(color: Colors.black)),
          leading:
              const Icon(Icons.local_shipping_outlined, color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, manageOrderProduct);
          },
        ),
      ],
    ));
  }
}
