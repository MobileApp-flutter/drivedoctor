import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/ordercontroller.dart';
import 'package:drivedoctor/bloc/models/order.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/orderservice.dart';
import 'package:flutter/material.dart';

class Manageorderbody extends StatefulWidget {
  const Manageorderbody({Key? key}) : super(key: key);

  @override
  State<Manageorderbody> createState() => _ManageorderbodyState();
}

class _ManageorderbodyState extends State<Manageorderbody> {
  final OrderController orderController = OrderController();
  final OrderService orderService = OrderService();
  bool pendingOrderExpanded = false;
  bool completedOrderExpanded = false;

  void _updateOrderStatus(String orderId) async {
    await orderService.updateOrder(
      orderId: orderId,
      orderStatus: 'complete',
    );

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, manageOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: Auth.getShopId(Auth.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final shopId = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.zero,
                  dividerColor: Colors.blue,
                  animationDuration: const Duration(milliseconds: 500),
                  children: [
                    pendingOrder(shopId),
                    completedOrder(shopId),
                  ],
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if (index == 0) {
                        pendingOrderExpanded = !isExpanded;
                      } else if (index == 1) {
                        completedOrderExpanded = !isExpanded;
                      }
                    });
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error retrieving shopId'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ExpansionPanel pendingOrder(String shopId) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text('Pending Order'),
        );
      },
      body: FutureBuilder<List<OrderData>>(
        future: orderController.getOrderServiceByShopID(shopId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<OrderData> orders = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OrderData order = orders[index];
                return FutureBuilder<UserData>(
                  future: Auth.getUserDataByUserId(order.userId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData) {
                      final userData = userSnapshot.data!;
                      return Column(
                        children: [
                          Container(
                            color: Colors.blue.shade50,
                            child: ListTile(
                              title: Text('Order id: ${order.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order type: ${order.orderType}'),
                                  const SizedBox(height: 20),

                                  //details on service
                                  if (order.orderType == 'service')
                                    Text(
                                        'Service name: ${order.service![0].servicename}'),

                                  // User details
                                  Text('Customer: ${userData.fullname}'),
                                  Text('Contact: ${userData.contact}'),

                                  const SizedBox(height: 10),

                                  ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 150,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Select Order Status:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Pending'),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          _updateOrderStatus(
                                                              order.orderId);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                        child: const Text(
                                                            'Complete'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(order.orderStatus ?? 'Unknown'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.blue.shade800,
                          ),
                        ],
                      );
                    } else {
                      return const Text("error");
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      isExpanded: pendingOrderExpanded,
    );
  }

  ExpansionPanel completedOrder(String shopId) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text('Completed Order'),
        );
      },
      body: FutureBuilder<List<OrderData>>(
        future: orderController.getCompleteOrderServiceByShopID(shopId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<OrderData> orders = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OrderData order = orders[index];
                return FutureBuilder<UserData>(
                  future: Auth.getUserDataByUserId(order.userId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData) {
                      final userData = userSnapshot.data!;
                      return Column(
                        children: [
                          Container(
                            color: Colors.blue
                                .shade50, // Set your desired background color here
                            child: ListTile(
                              title: Text('Order id: ${order.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order type: ${order.orderType}'),
                                  const SizedBox(height: 20),

                                  if (order.orderType == 'service')
                                    Text(
                                        'Service name: ${order.service![0].servicename}'),

                                  // User details
                                  Text('Customer: ${userData.fullname}'),
                                  Text('Contact: ${userData.contact}'),

                                  // add more details on product
                                  if (order.orderType == 'product')
                                    const Text('Product name:'),

                                  const SizedBox(height: 10),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .green, // Set the background color to green
                                    ),
                                    onPressed: () {},
                                    child: Text(order.orderStatus ?? 'Unknown'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.blue.shade800,
                          ),
                        ],
                      );
                    } else {
                      return const Text("error");
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      isExpanded: completedOrderExpanded,
    );
  }
}
