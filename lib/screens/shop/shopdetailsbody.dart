import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivedoctor/bloc/controller/servicecontroller.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/multiplearguments.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';

class Shopdetailsbody extends StatefulWidget {
  final ShopData shop;

  const Shopdetailsbody({Key? key, required this.shop}) : super(key: key);

  @override
  State<Shopdetailsbody> createState() => _ShopdetailsbodyState();
}

class _ShopdetailsbodyState extends State<Shopdetailsbody> {
  final ServiceController serviceController = ServiceController();
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
          child: Stack(
            children: <Widget>[
              Shoptitlepicture(shop: widget.shop),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.3),
                padding: EdgeInsets.only(top: size.height * 0.05, left: 30),
                height: 900,
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
                    Contactandrating(shop: widget.shop),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      // child: Text(
                      //   "shop descriptionr rjernieng riugneig nieugnrei nieung ie",
                      //   style: TextStyle(height: 1.5),
                      // ),
                    ),

                    //shop address text
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                            text: "Address\n",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: widget.shop.address),
                        ],
                      ),
                    ),

                    //list of services in the shop
                    const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "Services",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200.0,
                      child: FutureBuilder<List<ServiceData>>(
                        future: serviceController
                            .getServicesByShopId(widget.shop.shopId),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ServiceData>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const SizedBox(
                                height: 50.0,
                                child: Text('Error fetching services'));
                          } else if (snapshot.data!.isEmpty) {
                            return const SizedBox(
                                height: 50.0,
                                child: Text('No services added yet'));
                          } else {
                            final services = snapshot.data!;

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: services.length,
                              itemBuilder: (BuildContext context, int index) {
                                final service = services[index];

                                return SizedBox(
                                  width:
                                      200.0, // Adjust the width of each card as needed
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        serviceDetail,
                                        arguments: ShopServiceArguments(
                                            service.serviceId,
                                            widget.shop.shopId),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.blue[50],
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<List<String>>(
                                            future: storage
                                                .fetchImages(service.serviceId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError ||
                                                  !snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return Image.asset(
                                                  'assets/shop_image.jpg',
                                                  height: 100.0,
                                                  width: 150.0,
                                                  fit: BoxFit.cover,
                                                );
                                              } else {
                                                return CarouselSlider(
                                                  options: CarouselOptions(
                                                    height: 100.0,
                                                    aspectRatio: 16 / 9,
                                                    enlargeCenterPage: true,
                                                    enableInfiniteScroll: false,
                                                  ),
                                                  items: snapshot.data!
                                                      .map((image) {
                                                    return Image.network(
                                                      image,
                                                      fit: BoxFit.cover,
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  service.servicename,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Price: RM ${service.serviceprice}',
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  'Waiting Time: ${service.waittime}',
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class Contactandrating extends StatelessWidget {
  final ShopData shop;

  const Contactandrating({
    Key? key,
    required this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(shop.companyname),
              Text(shop.companycontact),
              Text(shop.companyemail),
            ],
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(text: "Shop rating\n"),
                TextSpan(
                  text: shop.rating.toStringAsFixed(2),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Shoptitlepicture extends StatefulWidget {
  final ShopData shop;

  const Shoptitlepicture({
    Key? key,
    required this.shop,
  }) : super(key: key);

  @override
  State<Shoptitlepicture> createState() => _ShoptitlepictureState();
}

class _ShoptitlepictureState extends State<Shoptitlepicture> {
  final Storage storage = Storage();
  final String imageName = 'shop.jpg';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<String>(
          future: storage.fetchShopProfilePicture(
            widget.shop.shopId,
            imageName,
          ),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Image.network(
                widget.shop.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
              );
            } else {
              String downloadUrl = snapshot.data?.toString() ?? '';
              final imageProvider = downloadUrl.isNotEmpty
                  ? NetworkImage(downloadUrl) as ImageProvider
                  : const AssetImage('assets/shop_image.jpg');

              return Image(
                image: imageProvider,
                fit: BoxFit.cover,
                //background blur
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.shop.shopname,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
