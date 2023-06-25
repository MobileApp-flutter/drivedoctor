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
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: shopAppBar(),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex: 3,
        ),
        body: GetAllOrders(
          orderController: orderController,
          storage: storage,
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
                        return const Text(
                            "No shop available"); // Display a placeholder image or widget
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
  // Widget _buildOrderProductItem(
  //   OrderData order,
  //   BuildContext context,
  //   int index,
  // ) {
  //   return SizedBox(
  //       height: 120,
  //       child: ListTile(
  //         contentPadding: const EdgeInsets.all(16.0),
  //         title: Text(
  //           order.product![index].productName,
  //         ),
  //       ));
  // }

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

            //check if car service is not empty
            if (orders != null && orders.isNotEmpty) {
              return SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        //check if order type is product or service
                        if (order.orderType == 'service') {
                          return Column(
                            children: [
                              for (int i = 0; i < order.service!.length; i++)
                                _buildOrderServiceItem(order, context, i),
                            ],
                          );
                          // } else if (order.orderType == 'product') {
                          //   return _buildOrderProductItem(order, context, index);
                        } else {
                          return const Center(child: Text('Not working'));
                        }
                      }));
            } else {
              return const Center(child: Text('No orders found'));
            }
          }
        });
  }
}
