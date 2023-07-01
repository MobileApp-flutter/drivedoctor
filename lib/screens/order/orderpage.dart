import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:drivedoctor/bloc/controller/ordercontroller.dart';
import 'package:drivedoctor/bloc/models/order.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Orderpage extends StatefulWidget {
  const Orderpage({Key? key}) : super(key: key);

  @override
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  final OrderController orderController = OrderController();
  final CartController cartController = CartController();
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: shopAppBar(),
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: 3,
          cartController: cartController,
        ),
        body: SingleChildScrollView(
          child: GetAllOrders(
            orderController: orderController,
            storage: storage,
          ),
        ));
  }

  AppBar shopAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, dashboard);
          },
          icon: const Icon(LineAwesomeIcons.angle_left)),
      title: const Text('Order List'),
      backgroundColor: Colors.blue.shade800,
    );
  }
}

class GetAllOrders extends StatelessWidget {
  const GetAllOrders({
    super.key,
    required this.orderController,
    required this.storage,
  });

  //order controller
  final OrderController orderController;

  //storage
  final Storage storage;

  //widget buildserviceitem
  Widget _buildOrderServiceItem(
    OrderData order,
    BuildContext context,
    int index,
  ) {
    return Column(
      children: [
        Container(
          height: 120,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FutureBuilder<List<String>>(
                  future: storage.fetchImages(
                      order.service![index].serviceId, true),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Image.asset(
                        'assets/shop_image.jpg',
                        height: 100.0,
                        width: 150.0,
                        fit: BoxFit.cover,
                      ); // Display a placeholder image or widget
                    } else {
                      final images = snapshot.data;
                      if (images != null && images.isNotEmpty) {
                        return Image.network(
                          images[0],
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset(
                          'assets/shop_image.jpg',
                          fit: BoxFit.cover,
                        ); // Display a placeholder image or widget
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      order.service![index].servicename,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'RM ${order.service![index].serviceprice}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: ${order.orderStatus}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.blue.shade800,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }

  //widget buildproductitem
  Widget _buildOrderProductItem(
    OrderData order,
    BuildContext context,
    int index,
  ) {
    return Column(
      children: [
        Container(
          height: 160,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FutureBuilder<List<String>>(
                  future: storage.fetchImages(
                      order.product![index].productId, false),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Image.asset(
                        'assets/shop_image.jpg',
                        height: 100.0,
                        width: 150.0,
                        fit: BoxFit.cover,
                      ); // Display a placeholder image or widget
                    } else {
                      final images = snapshot.data;
                      if (images != null && images.isNotEmpty) {
                        return Image.network(
                          images[0],
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset(
                          'assets/shop_image.jpg',
                          fit: BoxFit.cover,
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      order.product![index].productName,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Quantity: ${order.product![index].quantity}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Total price : RM ${order.product![index].price * order.product![index].quantity}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: ${order.product![index].productStatus}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Date order: ${_formatDateTime(order.orderDateCreate.toDate())}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.blue.shade800,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderData>>(
      future: orderController.getOrdersByUserID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error fetching orders'));
        } else {
          final orders = snapshot.data;

          if (orders != null && orders.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Service Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      if (order.orderType == 'service') {
                        return Column(
                          children: [
                            for (int i = 0; i < order.service!.length; i++)
                              _buildOrderServiceItem(order, context, i),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Product Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      if (order.orderType == 'product') {
                        return Column(
                          children: [
                            for (int i = 0; i < order.product!.length; i++)
                              _buildOrderProductItem(order, context, i),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No orders found'));
          }
        }
      },
    );
  }
}
