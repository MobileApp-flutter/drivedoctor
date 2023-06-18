import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/servicecontroller.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/multiplearguments.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../bloc/controller/auth.dart';
import '../../bloc/models/feedback.dart';
import '../../providers/user_provider.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../feedback/all_feedback.dart';
import '../feedback/create_feedback.dart';

class Shopdetailsbody extends StatefulWidget {
  final ShopData shop;

  const Shopdetailsbody({Key? key, required this.shop}) : super(key: key);

  @override
  State<Shopdetailsbody> createState() => _ShopdetailsbodyState();
}

class _ShopdetailsbodyState extends State<Shopdetailsbody> {
  final ServiceController serviceController = ServiceController();
  final Storage storage = Storage();
  List<FeedbackData> feedbacks = [];
  late ShopData shop;
  late double shopRating;
  late Size size;

  @override
    void initState() {
      super.initState();

      shop = widget.shop;
      updateFeedbacksAndRating();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          size = MediaQuery.of(context).size;
        });
      });
    }

  List<ServiceData> services = [];

  Future<void> updateFeedbacksAndRating() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedbacks')
        .where('shopId', isEqualTo: shop.shopId)
        .get();

    feedbacks = querySnapshot.docs
        .map((doc) => FeedbackData.fromSnapshot(doc))
        .toList() as List<FeedbackData>;

    double totalRating = 0.0;
    for (final feedback in feedbacks) {
      totalRating += feedback.rating;
    }
    shopRating = feedbacks.isNotEmpty ? totalRating / feedbacks.length : 0.0;

    await FirebaseFirestore.instance
        .collection('shops')
        .doc(shop.shopId)
        .update({'rating': shopRating});
  }

  void navigateToFeedbackPage(String userId, String shopId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateFeedbackPage(
          shopId: shopId,
          userId: userId,
          updateFeedbacks: updateFeedbacksAndRating,
        ),
      ),
    );
    await updateFeedbacksAndRating();
  }

  Future<void> navigateToAllFeedbacksPage() async {
    List<FeedbackData> feedbacks = await fetchFeedbacks();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllFeedbacksPage(
          feedbacks: feedbacks,
          updateFeedbacks: updateFeedbacksAndRating,
        ),
      ),
    );
  }

  // Fetch feedbacks from Firestore
  Future<List<FeedbackData>> fetchFeedbacks() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedbacks')
        .where('shopId', isEqualTo: shop.shopId)
        .get();

    return querySnapshot.docs.map((doc) {
      return FeedbackData.fromSnapshot(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;

    return Scaffold(
      body: FutureBuilder(
        future: serviceController.getServices(shop.shopId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            services = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    //height: size.height,
                    child: Stack(
                      children: <Widget>[
                        Shoptitlepicture(shop: widget.shop),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.3),
                          padding: EdgeInsets.only(
                              top: size.height * 0.05, left: 30),
                          //height: 900,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 200.0,
                                child: FutureBuilder<List<ServiceData>>(
                                  future: serviceController
                                      .getServicesByShopId(widget.shop.shopId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<ServiceData>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return const SizedBox(
                                          height: 50.0,
                                          child:
                                              Text('Error fetching services'));
                                    } else if (snapshot.data!.isEmpty) {
                                      return const SizedBox(
                                          height: 50.0,
                                          child: Text('No services added yet'));
                                    } else {
                                      final services = snapshot.data!;

                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: services.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final service = services[index];

                                          return SizedBox(
                                            width:
                                                200.0, // Adjust the width of each card as needed
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  serviceDetail,
                                                  arguments:
                                                      ShopServiceArguments(
                                                          service.serviceId,
                                                          widget.shop.shopId),
                                                );
                                              },
                                              child: Card(
                                                color: Colors.blue[50],
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FutureBuilder<List<String>>(
                                                      future: storage
                                                          .fetchImages(service
                                                              .serviceId),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else if (snapshot
                                                                .hasError ||
                                                            !snapshot.hasData ||
                                                            snapshot.data!
                                                                .isEmpty) {
                                                          return Image.asset(
                                                            'assets/shop_image.jpg',
                                                            height: 100.0,
                                                            width: 150.0,
                                                            fit: BoxFit.cover,
                                                          );
                                                        } else {
                                                          return CarouselSlider(
                                                            options:
                                                                CarouselOptions(
                                                              height: 100.0,
                                                              aspectRatio:
                                                                  16 / 9,
                                                              enlargeCenterPage:
                                                                  true,
                                                              enableInfiniteScroll:
                                                                  false,
                                                            ),
                                                            items: snapshot
                                                                .data!
                                                                .map((image) {
                                                              return Image
                                                                  .network(
                                                                image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                            }).toList(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            service.servicename,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Price: RM ${service.serviceprice}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Waiting Time: ${service.waittime}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
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
                              const SizedBox(height:10),
                              // Show latest feedback and rating
                              const SizedBox(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.feedback,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Latest Feedback and Rating',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Button to view all feedbacks
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: navigateToAllFeedbacksPage,
                                  child: const Text('View All Feedbacks'),
                                ),
                              ),

                              // Display latest feedbacks and ratings
                              Container(
                                child: FutureBuilder<List<FeedbackData>>(
                                  future:
                                      fetchFeedbacks(), // Fetch feedbacks using the method
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      print(
                                          'Error fetching feedbacks: ${snapshot.error}');
                                      return Text(
                                          'Error fetching feedbacks: ${snapshot.error}');
                                    } else {
                                      final feedbacks = snapshot.data;

                                      return feedbacks != null &&
                                              feedbacks.isNotEmpty
                                          ? ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: feedbacks.length > 5
                                                  ? 5
                                                  : feedbacks.length,
                                              separatorBuilder:
                                                  (context, index) => Divider(),
                                              itemBuilder: (context, index) {
                                                final feedback =
                                                    feedbacks[index];

                                                return Card(
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          feedback.userEmail,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10.0),
                                                        RatingBarIndicator(
                                                          rating:
                                                              feedback.rating,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 20.0,
                                                          direction:
                                                              Axis.horizontal,
                                                        ),
                                                        const SizedBox(
                                                            height: 10.0),
                                                        Text(
                                                          feedback.text,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : const Text(
                                              'No feedbacks available');
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToFeedbackPage(userId, shop.shopId);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
