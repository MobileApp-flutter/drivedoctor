import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/controller/shopController.dart';
import 'package:drivedoctor/bloc/controller/productController.dart';

import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchOption = 'all'; // Add searchOption variable
  List<ShopData> shops = [];
  List<ProductData> products = [];

  @override
  Widget build(BuildContext context) {
    final ShopController _shopController = ShopController();
    final ProductController _productController = ProductController();

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
            FutureBuilder<UserData>(
              future:
                  Auth.getUserDataByEmail(Auth.email), // pass email as argument
              builder: (context, snapshot) {
                final username = snapshot.data?.username;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  // check if snapshot has data
                  return const Text('Welcome, Guest');
                } else {
                  return Text(
                    'Welcome, $username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            )
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Add Radio buttons for search options
                  Row(
                    children: [
                      buildSearchOption('All', 'all'),
                      buildSearchOption('Shop', 'shop'),
                      buildSearchOption('Product', 'product'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Car Services',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // View All button clicked
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 200.0,
              child: FutureBuilder<List<ShopData>>(
                future: _shopController.getShops(), // Retrieve shops data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final shops = snapshot.data;
                    if (shops != null && shops.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shops.length,
                        itemBuilder: (BuildContext context, int index) {
                          final shop = shops[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  shop.imageUrl,
                                  height: 100.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.shopname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Rating: ${shop.rating}'),
                                      Text(shop.companyname),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Text('No car services available');
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shop Now',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // View All button clicked
                    },
                    child: Text('View All'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 200.0,
              child: FutureBuilder<List<ProductData>>(
                future:
                    _productController.getProducts(), // Retrieve products data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    print('Snapshot data: ${snapshot.data}');
                    final products = snapshot.data;
                    if (products != null && products.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product.imageUrl,
                                  height: 120.0,
                                  width: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Price: \$${product.price.toStringAsFixed(2)}',
                                      ),
                                      FutureBuilder<ShopData?>(
                                        future: _shopController
                                            .getShopById(product.shopId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('Error fetching shop');
                                          } else {
                                            final shop = snapshot.data;
                                            if (shop != null) {
                                              return Text(shop.shopname);
                                            } else {
                                              return Text('Shop not found');
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Text('No products available');
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Go to MyShop button clicked
                },
                icon: Icon(Icons.shop), // Add the shop icon
                label: Text('Go to My Shop'),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildSearchOption(String text, String value) {
    final isSelected = searchOption == value;
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: searchOption,
          onChanged: (String? newValue) {
            setState(() {
              searchOption = newValue!;
            });
          },
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
