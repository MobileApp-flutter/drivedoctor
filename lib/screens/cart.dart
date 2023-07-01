import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/orderservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  CartController? cartController;

  CartPage({
    Key? key,
    this.cartController,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _voucherRedemption = false;
  String _selectedPaymentMethod = 'Credit Card';
  String _selectedShipping = 'Standard Delivery';

  final Storage storage = Storage();
  final OrderService orderproduct = OrderService();

  //method to create product
  void createOrderProduct() async {
    //get current user uid
    final currentUser = FirebaseAuth.instance.currentUser;

    // Create a list of ProductData from cartItems, including the quantity
    final List<ProductData> products =
        widget.cartController!.cartItems.map((cartItem) {
      final product = cartItem.product;
      product.quantity = cartItem.quantity;
      return product;
    }).toList();

    //create order
    await orderproduct.createOrderProduct(
      orderType: 'product',
      userId: currentUser?.uid,
      product: products,
      totalPrice: _calculateTotalPrice(),
    );

    //create confirmation tab
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: const Text('Your order has been created'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, dashboard);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, marketDashboard,
                  arguments: widget.cartController);
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cartController?.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = widget.cartController?.cartItems[index];
              final product = cartItem?.product;
              if (product != null) {
                int? quantity = cartItem?.quantity;
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .cardColor, // Match the app's card color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: FutureBuilder<List<String>>(
                      future: storage.fetchImages(
                          cartItem!.product.productId, false),
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
                            width: 90.0,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Image.network(
                            snapshot.data!.first,
                            height: 100.0,
                            width: 90.0,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                    title: Text(cartItem.product.productName),
                    subtitle:
                        Text('RM${cartItem.product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity! > 1) {
                              widget.cartController!
                                  .removeFromCart(cartItem.product);
                            } else {
                              widget.cartController!
                                  .removeFromCartCompletely(cartItem.product);
                            }
                            setState(
                                () {}); // Update the UI after removing from the cart
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            widget.cartController!.addToCart(cartItem.product);
                            setState(
                                () {}); // Update the UI after adding to the cart
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Payment Method'),
                  trailing: DropdownButton<String>(
                    value: _selectedPaymentMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPaymentMethod = newValue!;
                      });
                    },
                    items: <String>[
                      'Credit Card',
                      'PayPal',
                      'Google Pay',
                      'Apple Pay',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Shipping'),
                  trailing: DropdownButton<String>(
                    value: _selectedShipping,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedShipping = newValue!;
                      });
                    },
                    items: <String>[
                      'Standard Delivery',
                      'Express Delivery',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Voucher Redemption'),
                  trailing: Switch(
                    value: _voucherRedemption,
                    onChanged: (bool value) {
                      setState(() {
                        _voucherRedemption = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'RM${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Perform checkout logic here
                createOrderProduct();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor:
                    Colors.blue, // Set your desired button color here
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set your desired text color here
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: 1, cartController: widget.cartController),
    );
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var cartItem in widget.cartController!.cartItems) {
      totalPrice += cartItem.product.price * cartItem.quantity;
    }
    return totalPrice;
  }
}
