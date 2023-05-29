import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/controller/shopController.dart';
import 'package:drivedoctor/bloc/controller/productcontroller.dart';
import 'package:drivedoctor/screens/dashboard/searchresult.dart';

import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation_bar.dart';
import 'allproduct.dart';
import 'allshop.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchOption = 'all'; // Add searchOption variable
  List<ShopData> shops = [];
  List<ProductData> products = [];
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = ShopController();
    final ProductController productController = ProductController();

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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Call the updateFilteredItems function when the search icon is pressed
                          updateFilteredItems(searchTextController.text);
                        },
                      ),
                    ),
                    controller: searchTextController,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarServiceShopListPage()),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: FutureBuilder<List<ShopData>>(
                future: shopController.getShops(), // Retrieve shops data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    shops = snapshot.data ?? [];
                    if (shops.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shops.length,
                        itemBuilder: (BuildContext context, int index) {
                          final shop = shops[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.shopname,
                                        style: const TextStyle(
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
                      return const Text('No car services available');
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shop Now',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // View All button clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListPage()),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 200.0,
              child: FutureBuilder<List<ProductData>>(
                future:
                    productController.getProducts(), // Retrieve products data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    products = snapshot.data ?? [];
                    if (products.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Price: RM${product.price.toStringAsFixed(2)}',
                                      ),
                                      FutureBuilder<ShopData?>(
                                        future: shopController
                                            .getShopById(product.shopId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                                'Error fetching shop');
                                          } else {
                                            final shop = snapshot.data;
                                            if (shop != null) {
                                              return Text(shop.shopname);
                                            } else {
                                              return const Text(
                                                  'Shop not found');
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
                      return const Text('No products available');
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Go to MyShop button clicked
                },
                icon: const Icon(Icons.shop), // Add the shop icon
                label: const Text('Go to My Shop'),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void updateFilteredItems(String searchText) {
    // Update the filtered shops and products lists based on the search text and search option
    if (searchOption == 'all') {
      // Filter both shops and products
      final filteredShops = shops
          .where((shop) =>
              shop.shopname.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      final filteredProducts = products
          .where((product) => product.productName
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();

      // Navigate to the search results page with the filtered lists
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(
            searchOption: searchOption,
            shops: filteredShops,
            products: filteredProducts,
          ),
        ),
      );
    } else if (searchOption == 'shop') {
      // Filter only shops
      final filteredShops = shops.where((shop) =>
          shop.shopname.toLowerCase().contains(searchText.toLowerCase()));

      // Navigate to the search results page with the filtered list of shops
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(
            searchOption: searchOption,
            shops: filteredShops.toList(),
            products: const [],
          ),
        ),
      );
    } else if (searchOption == 'product') {
      // Filter only products
      final filteredProducts = products.where((product) =>
          product.productName.toLowerCase().contains(searchText.toLowerCase()));

      // Navigate to the search results page with the filtered list of products
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(
            searchOption: searchOption,
            shops: const [],
            products: filteredProducts.toList(),
          ),
        ),
      );
    }
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
