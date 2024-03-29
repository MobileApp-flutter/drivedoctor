import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../bloc/controller/productController.dart';
import '../../bloc/models/product.dart';

class ProductListPage extends StatelessWidget {
  final ProductController _productController = ProductController();
  final Storage storage = Storage();

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, dashboard);
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text('Product List'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productController.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching products'));
          } else {
            final products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => Divider(
                  color:
                      Colors.blue.shade800, // Set the color of the divider here
                  height: 2, // Set the height of the divider here
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    height: 120, // Adjust the height as desired
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: SizedBox(
                        width: 80,
                        height: 80,
                        child: FutureBuilder<List<String>>(
                          future: storage.fetchImages(product.productId, false),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
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
                                items: snapshot.data!.map((image) {
                                  return Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                      title: Text(
                        product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'RM${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle the tap on a specific product
                        _navigateToProductDetails(context, product.productId);
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No products available'));
            }
          }
        },
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, String productId) {
    // Navigate to the product details page
    // pass the productId to the details page to fetch and display the details of the specific product
    /*Navigator.of(context).pushNamed(
      AppRoutes.productDetails,
      arguments: productId,
    );*/
  }
}
