import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/carservices/servicedetailsbody.dart';
import 'package:drivedoctor/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Servicedetails extends StatefulWidget {
  final String shopId;
  final String serviceId;

  const Servicedetails(
      {Key? key, required this.serviceId, required this.shopId})
      : super(key: key);

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  final CartController cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade800,
        appBar: buildServiceDetailsAppBar(context),
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: 0,
          cartController: cartController,
        ),
        body: FutureBuilder<ServiceData>(
            future: Auth.getServiceDataByServiceId(widget.serviceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                final service = snapshot.data!;
                return Servicedetailsbody(
                  service: service,
                );
              }
            }));
  }

  AppBar buildServiceDetailsAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade800,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            //return to shop detail page
            Navigator.pushReplacementNamed(
              context,
              shopDetail,
              arguments: widget.shopId, // Pass the shopId argument
            );
          },
          icon: const Icon(LineAwesomeIcons.angle_left)),
      //put text
      title: const Text('Service Details'),
    );
  }
}
