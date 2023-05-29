import 'package:flutter/material.dart';
import '../../bloc/controller/productController.dart';
import '../../bloc/models/product.dart';

class ProductListPage extends StatelessWidget {
  final ProductController _productController = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productController.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching products'));
          } else {
            final products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    height: 120, // Adjust the height as desired
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Container(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.productName,
                        style: TextStyle(
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 12),
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
              return Center(child: Text('No products available'));
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
