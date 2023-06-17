import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/controller/productController.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/screens/cart.dart';
import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';

class MarketDashboardPage extends StatefulWidget {
  @override
  _MarketDashboardPageState createState() => _MarketDashboardPageState();
}

class _MarketDashboardPageState extends State<MarketDashboardPage> {
  final ProductController _productController = ProductController();
  int _currentIndex = 2; // Set the initial index for the bottom navigation bar

  final CartController _cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Dashboard'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      radius: 10,
                      child: Text(
                        _cartController.cartItems.length.toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _navigateToCart(context);
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productController.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching products'));
          } else {
            final products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Container(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _addToCart(product);
                        },
                      ),
                      onTap: () {
                        _navigateToProductDetails(context, product.productId);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No products available'));
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
      ),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(cartController: _cartController)),
    );
  }

  void _addToCart(ProductData product) {
    _cartController.addToCart(product);
    setState(() {}); // Update the UI after adding the item to the cart
  }

  void _navigateToProductDetails(BuildContext context, String productId) {
    // Navigate to the product details page
    /*Navigator.of(context).pushNamed(
      AppRoutes.productDetails,
      arguments: productId,
    );*/
  }
}
