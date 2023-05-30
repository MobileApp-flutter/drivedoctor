import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../bloc/controller/shopController.dart';
import '../../bloc/models/shop.dart';

class CarServiceShopListPage extends StatelessWidget {
  final ShopController _shopController = ShopController();

  CarServiceShopListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, dashboard);
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text('Shop List'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder<List<ShopData>>(
        future: _shopController.getShops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
                child: Text('Error fetching car service shops'));
          } else {
            final carServices = snapshot.data;
            if (carServices != null && carServices.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: carServices.length,
                  itemBuilder: (context, index) {
                    final carService = carServices[index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                carService.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              carService.shopname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.yellow),
                                    const SizedBox(width: 4.0),
                                    Text(carService.rating.toString()),
                                  ],
                                ),
                                Text(
                                  carService.address,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Handle the tap on a specific car service shop
                              _navigateToCarServiceShopDetails(
                                context,
                                carService.shopId,
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.blue.shade800,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        ), // Customized divider
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(
                  child: Text('No car service shops available'));
            }
          }
        },
      ),
    );
  }

  void _navigateToCarServiceShopDetails(BuildContext context, String shopId) {
    // Navigate to the car service shop details page
    // pass the shopId to the details page to fetch and display the details of the specific shop
    /*Navigator.of(context).pushNamed(
      AppRoutes.carServiceShopDetails,
      arguments: shopId,
    );*/
  }
}
