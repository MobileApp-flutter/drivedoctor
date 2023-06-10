import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/servicecontroller.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/widgets/shop_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../bloc/models/feedback.dart';
import '../../providers/user_provider.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../feedback/all_feedback.dart';
import '../feedback/create_feedback.dart';
import '../feedback/feedback_page.dart';

class Shopdashboard extends StatefulWidget {
  const Shopdashboard({Key? key}) : super(key: key);

  @override
  State<Shopdashboard> createState() => _ShopdashboardState();
}

class _ShopdashboardState extends State<Shopdashboard> {
  final Storage storage = Storage();
  String imageName = 'shop.jpg';
  late ShopData shop;
  List<FeedbackData> feedbacks = [];
  late double shopRating;

  List<ServiceData> services = [];

  @override
  void initState() {
    super.initState();
    shopRating = 0.0;
    feedbacks = [];

    Auth.getShopDataByEmail(Auth.email).then((shopData) {
      setState(() {
        shop = shopData;
      });
    });

    // Call the method to fetch feedbacks and calculate the average rating
    updateFeedbacksAndRating();
  }

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

  void navigateToAllFeedbacksPage() {
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

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = ServiceController();
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.userId;

    return SafeArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue.shade800,
                    child: Image.asset(
                      'assets/logo_white.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FutureBuilder<ShopData>(
                  future: Auth.getShopDataByEmail(
                      Auth.email), // pass email as argument
                  builder: (context, snapshot) {
                    final shopname = snapshot.data?.shopname;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      // check if snapshot has data
                      return const Text('You have not registered the shop');
                    } else {
                      return Text(
                        'Welcome, $shopname',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            backgroundColor: Colors.blue.shade800,
          ),
          drawer: const Drawer(
            child: ShopSideMenu(),
          ),
          bottomNavigationBar: const BottomNavigationBarWidget(
            currentIndex:
                0, // Replace with your current index variable// Replace with your onTabTapped callback function
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<String>(
                      future: storage.fetchShopProfilePicture(imageName),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While waiting for the future to resolve
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('You have not registered the shop');
                        } else {
                          String downloadUrl = snapshot.data?.toString() ?? '';
                          final imageProvider = downloadUrl.isNotEmpty
                              ? NetworkImage(downloadUrl) as ImageProvider
                              : const AssetImage('assets/shop_image.jpg');

                          return Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                    FutureBuilder<ShopData>(
                      future: Auth.getShopDataByEmail(Auth.email),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('You have not registered the shop');
                        } else {
                          final shopname = snapshot.data!.shopname;
                          final address = snapshot.data!.address;
                          shop = snapshot.data!;

                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  shopname,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  address,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, addService);
                        },
                        child: const Icon(
                          Icons.add_circle_outlined,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120.0,
                  child: FutureBuilder<List<ServiceData>>(
                    future: serviceController.getServices(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        services = snapshot.data ?? [];
                        if (services.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: services.length,
                            itemBuilder: (BuildContext context, int index) {
                              final service = services[index];

                              return SizedBox(
                                height:
                                    100.0, // Set the desired height for the card
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Set the border radius
                                  ),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Set the same border radius for the container
                                      color: Colors.blue,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              service.servicename,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .white, // Set the text color to white
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20.0),
                                        Center(
                                          child: Text(
                                            'Price: RM ${service.serviceprice}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors
                                                  .white, // Set the text color to white
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: Text(
                                            'Waiting Time: ${service.waittime}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors
                                                  .white, // Set the text color to white
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No services found');
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushReplacementNamed(context, addService);
                        },
                        child: const Icon(
                          Icons.add_circle_outlined,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Products (still in development)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://soyacincau.com/wp-content/uploads/2021/08/210805-GoCar_garage-1.jpg',
                              height: 100.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Show latest feedback and rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.feedback,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Latest Feedback and Rating',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                SizedBox(
                  height: 120.0,
                  child: feedbacks.isNotEmpty
                      ? Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  feedbacks.first.userId,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                RatingBarIndicator(
                                  rating: shopRating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  feedbacks.first.text,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: Text('No feedbacks available')),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToFeedbackPage(userId, shop.shopId);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}
