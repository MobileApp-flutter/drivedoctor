import 'dart:developer';

import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/servicecontroller.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation_bar.dart';

class Shopdashboard extends StatefulWidget {
  const Shopdashboard({Key? key}) : super(key: key);

  @override
  State<Shopdashboard> createState() => _ShopdashboardState();
}

class _ShopdashboardState extends State<Shopdashboard> {
  List<ServiceData> services = [];

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = ServiceController();

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<ShopData>(
                  future: Auth.getShopDataByEmail(Auth.email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Text('You have not registered the shop');
                    } else {
                      final shopname = snapshot.data!.shopname;
                      final address = snapshot.data!.address;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/shop_image.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              shopname,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              address,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, addService);
                    },
                    child: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Your Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120.0,
              child: FutureBuilder<List<ServiceData>>(
                future: serviceController.getServices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  } else {
                    services = snapshot.data ?? [];
                    if (services.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          final service = services[index];

                          return SizedBox(
                            height:
                                100.0, // Set the desired height for the card
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Set the border radius
                              ),
                              margin: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Set the same border radius for the container
                                  color: Colors.blue,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          service.servicename,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .white, // Set the text color to white
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    Center(
                                      child: Text(
                                        'Price: RM ${service.serviceprice}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors
                                              .white, // Set the text color to white
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Center(
                                      child: Text(
                                        'Waiting Time: ${service.waittime}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors
                                              .white, // Set the text color to white
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('No services found');
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacementNamed(context, addService);
                    },
                    child: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Your Products (still in development)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
