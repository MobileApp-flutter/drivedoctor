import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/management/manageorderservicebody.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Manageorder extends StatelessWidget {
  const Manageorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildManageorderAppBar(context),
      body: const Center(
        child: Manageorderbody(),
      ),
    );
  }

  AppBar buildManageorderAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, shopDashboard);
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Manage Order Service'));
  }
}
