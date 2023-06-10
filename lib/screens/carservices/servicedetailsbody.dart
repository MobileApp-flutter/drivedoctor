import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/screens/carservices/servicecarouselpicture.dart';
import 'package:flutter/material.dart';

class Servicedetailsbody extends StatefulWidget {
  final ServiceData service;

  const Servicedetailsbody({Key? key, required this.service}) : super(key: key);

  @override
  State<Servicedetailsbody> createState() => _ServicedetailsbodyState();
}

class _ServicedetailsbodyState extends State<Servicedetailsbody> {
  final Storage storage = Storage();

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
              Container(),
              Servicecarouselpicture(service: widget.service),
            ]))
      ],
    ));
  }
}
