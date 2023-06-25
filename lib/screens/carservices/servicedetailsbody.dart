import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/orderservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/screens/carservices/servicecarouselpicture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Servicedetailsbody extends StatefulWidget {
  final ServiceData service;

  const Servicedetailsbody({Key? key, required this.service}) : super(key: key);

  @override
  State<Servicedetailsbody> createState() => _ServicedetailsbodyState();
}

class _ServicedetailsbodyState extends State<Servicedetailsbody> {
  final Storage storage = Storage();
  final OrderService orderservice = OrderService();

  //method to create order
  void createOrderService() async {
    //get current user uid
    final currentUser = FirebaseAuth.instance.currentUser;

    //create order
    await orderservice.createOrderService(
      orderType: 'service',
      orderStatus: 'pending',
      userId: currentUser?.uid,
      shopId: widget.service.shopId,
      service: [widget.service],
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
              Navigator.pushReplacementNamed(context, shopDetail,
                  arguments: widget.service.shopId);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            height: size.height,
            child: Stack(children: <Widget>[
              Container(
                width: double.infinity, // Expand to fill the available width
                margin: EdgeInsets.only(top: size.height * 0.3),
                padding: EdgeInsets.only(
                    top: size.height * 0.05, left: 30, right: 30),
                height: 600,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    //service title
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: widget.service.servicename,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //service details (price, description etc)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.service.servicedesc,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                            text: "RM ",
                          ),
                          TextSpan(text: widget.service.serviceprice),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                            text: "Waiting time: ",
                          ),
                          TextSpan(text: widget.service.waittime),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                              createOrderService();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.blue
                                  .shade800, // Set the desired button color here
                            ),
                            child: const Text('Get Service'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Servicecarouselpicture(service: widget.service),
            ]))
      ],
    ));
  }
}
