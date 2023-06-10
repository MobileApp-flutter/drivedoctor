import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/shop/shopdetailsbody.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Shopdetails extends StatefulWidget {
  final String shopId;

  const Shopdetails({Key? key, required this.shopId}) : super(key: key);

  @override
  State<Shopdetails> createState() => _ShopdetailsState();
}

class _ShopdetailsState extends State<Shopdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade800,
        appBar: buildShopDetailsAppBar(context),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex: 0,
        ),
        body: FutureBuilder<ShopData>(
            future: Auth.getShopDataByShopId(widget.shopId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                final shop = snapshot.data!;
                return Shopdetailsbody(
                  shop: shop,
                );
              }
            })
        // body: const Shopdetailsbody(),
        );
  }

  AppBar buildShopDetailsAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade800,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, dashboard);
          },
          icon: const Icon(LineAwesomeIcons.angle_left)),
      //put text
      title: const Text('Shop Details'),
    );
  }
}
