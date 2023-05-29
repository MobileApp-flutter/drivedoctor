import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/authservice.dart';
import 'package:drivedoctor/bloc/services/shopservice.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/profile/update_profile.dart';
import 'package:drivedoctor/widgets/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../widgets/bottom_navigation_bar.dart';

class Shopdashboard extends StatelessWidget {
  const Shopdashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue.shade800,
                child: Image.asset(
                  'assets/logo_white.png',
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            const SizedBox(width: 10),
            FutureBuilder<ShopData>(
              future:
                  Auth.getShopDataByEmail(Auth.email), // pass email as argument
              builder: (context, snapshot) {
                final shopname = snapshot.data?.shopname;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  // check if snapshot has data
                  return const Text('You have not registered the shop');
                } else {
                  return Text(
                    'Welcome, $shopname',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentIndex:
            0, // Replace with your current index variable// Replace with your onTabTapped callback function
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<ShopData>(
                  future: Auth.getShopDataByEmail(
                      Auth.email), // pass email as argument
                  builder: (context, snapshot) {
                    final shopname = snapshot.data?.shopname;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      // check if snapshot has data
                      return const Text('You have not registered the shop');
                    } else {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/shop_image.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<ShopData>(
                    future: Auth.getShopDataByEmail(
                        Auth.email), // pass email as argument
                    builder: (context, snapshot) {
                      final shopname = snapshot.data?.shopname;
                      final address = snapshot.data?.address;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        // check if snapshot has data
                        return const Text('You have not registered the shop');
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                shopname!,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Address: $address',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, addService);
                    },
                    child: Text('Add Services'),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://soyacincau.com/wp-content/uploads/2021/08/210805-GoCar_garage-1.jpg',
                          height: 100.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      DoNothingAction;
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://soyacincau.com/wp-content/uploads/2021/08/210805-GoCar_garage-1.jpg',
                          height: 100.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
