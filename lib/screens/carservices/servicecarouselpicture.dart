import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';

class Servicecarouselpicture extends StatefulWidget {
  final ServiceData service;

  const Servicecarouselpicture({Key? key, required this.service})
      : super(key: key);

  @override
  State<Servicecarouselpicture> createState() => _ServicecarouselpictureState();
}

class _ServicecarouselpictureState extends State<Servicecarouselpicture> {
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<String>>(
            future: storage.fetchImages(widget.service.serviceId),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Image.asset(
                  'assets/shop_image.jpg',
                  height: 100.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                );
              } else {
                return SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Set the width to screen width
                  child: CarouselSlider(
                    options: CarouselOptions(
                      // height: 100.0,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                    items: snapshot.data!.map((image) {
                      return Image.network(
                        //darken the image
                        image,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                );
              }
            }),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Text(
        //         widget.service.servicename,
        //         style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //             ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
