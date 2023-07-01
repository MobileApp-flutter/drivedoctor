import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/controller/productController.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/screens/cart.dart';
import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MarketDashboardPage extends StatefulWidget {
  CartController? cartController;

  MarketDashboardPage({Key? key, this.cartController}) : super(key: key);

  @override
  State<MarketDashboardPage> createState() => _MarketDashboardPageState();
}

class _MarketDashboardPageState extends State<MarketDashboardPage> {
  final ProductController _productController = ProductController();
  final int _currentIndex =
      2; // Set the initial index for the bottom navigation bar

  final CartController _cartController = CartController();
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Market Dashboard'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      radius: 10,
                      child: Text(
                        widget.cartController?.cartItems.length.toString() ??
                            '0',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if (widget.cartController != null) {
                  _navigateToCart(context);
                }
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productController.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching products'));
          } else {
            final products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: FutureBuilder<List<String>>(
                        future: storage.fetchImages(product.productId, false),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Image.asset(
                              'assets/shop_image.jpg',
                              height: 100.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.network(
                              snapshot.data!.first,
                              height: 100.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                      title: Text(
                        product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RM${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _addToCart(product);
                        },
                      ),
                      onTap: () {
                        _showProductDetailsDialog(context, product);
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No products available'));
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: _currentIndex, cartController: _cartController),
    );
  }

  @override
  void initState() {
    super.initState();
    _retrieveCartItems();
  }

  void _retrieveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems');
    if (cartItems != null) {
      _cartController.setCartItems(cartItems);
    }
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(cartController: _cartController)),
    );
  }

  Future<void> _addToCart(ProductData product) async {
    _cartController.addToCart(product);

    // Store the updated cart items in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cartItems', _cartController.tempCart);

    setState(() {}); // Update the UI after adding the item to the cart
  }

  void _showProductDetailsDialog(BuildContext context, ProductData product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: FutureBuilder<List<String>>(
                    future: storage.fetchImages(product.productId, false),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Image.asset(
                          'assets/shop_image.jpg',
                          height: 100.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.network(
                          snapshot.data!.first,
                          height: 100.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Rating: ${product.rating}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stock: ${product.stock}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Sold: ${product.totalSold}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
