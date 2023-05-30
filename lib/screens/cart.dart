import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatefulWidget {
  final CartController cartController;

  const CartPage({Key? key, required this.cartController}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _voucherRedemption = false;
  String _selectedPaymentMethod = 'Credit Card';
  String _selectedShipping = 'Standard Delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartController.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartController.cartItems[index];
                int quantity = cartItem.quantity;
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .cardColor, // Match the app's card color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: cartItem.product.imageUrl,
                      height: 80,
                      width: 80,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(cartItem.product.productName),
                    subtitle:
                        Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              widget.cartController
                                  .removeFromCart(cartItem.product);
                            } else {
                              widget.cartController
                                  .removeFromCartCompletely(cartItem.product);
                            }
                            setState(
                                () {}); // Update the UI after removing from the cart
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            widget.cartController.addToCart(cartItem.product);
                            setState(
                                () {}); // Update the UI after adding to the cart
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text('Payment Method'),
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
                  title: Text('Shipping'),
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
                  title: Text('Voucher Redemption'),
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
          SizedBox(height: 16),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Perform checkout logic here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                primary: Colors.blue, // Set your desired button color here
              ),
              child: Text(
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
    );
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var cartItem in widget.cartController.cartItems) {
      totalPrice += cartItem.product.price * cartItem.quantity;
    }
    return totalPrice;
  }
}
