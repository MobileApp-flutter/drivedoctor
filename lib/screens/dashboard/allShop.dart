import 'package:flutter/material.dart';
import '../../bloc/controller/shopController.dart';
import '../../bloc/models/shop.dart';

class CarServiceShopListPage extends StatelessWidget {
  final ShopController _shopController = ShopController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Service Shops'),
      ),
      body: FutureBuilder<List<ShopData>>(
        future: _shopController.getShops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching car service shops'));
          } else {
            final carServices = snapshot.data;
            if (carServices != null && carServices.isNotEmpty) {
              return ListView.builder(
                itemCount: carServices.length,
                itemBuilder: (context, index) {
                  final carService = carServices[index];
                  return Container(
                    height: 120,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Container(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          carService.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        carService.shopname,
                        style: TextStyle(
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
                              Icon(Icons.star, color: Colors.yellow),
                              SizedBox(width: 4.0),
                              Text(carService.rating.toString()),
                            ],
                          ),
                          Text(
                            carService.address,
                            style: TextStyle(fontSize: 12),
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
                  );
                },
              );
            } else {
              return Center(child: Text('No car service shops available'));
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
