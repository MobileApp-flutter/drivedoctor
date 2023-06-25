import 'package:flutter/material.dart';
import '../../bloc/models/shop.dart';
import '../../bloc/models/product.dart';

class SearchResultsPage extends StatelessWidget {
  final String searchOption;
  final List<ShopData> shops;
  final List<ProductData> products;

  const SearchResultsPage({
    Key? key,
    required this.searchOption,
    required this.shops,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> results;
    if (searchOption == 'all') {
      results = [...shops, ...products];
    } else if (searchOption == 'shop') {
      results = shops;
    } else if (searchOption == 'product') {
      results = products;
    } else {
      results = Null as List;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results - $searchOption'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          if (result is ShopData) {
            return _buildShopItem(result, context);
          } else if (result is ProductData) {
            return _buildProductItem(result, context);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildShopItem(ShopData shop, BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
            shop.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          shop.shopname,
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
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4.0),
                Text(shop.rating.toString()),
              ],
            ),
            Text(
              shop.address,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          _navigateToShopDetails(context, shop.shopId);
        },
      ),
    );
  }

  Widget _buildProductItem(ProductData product, BuildContext context) {
    return SizedBox(
      height: 120, // Adjust the height as desired
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
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
          _navigateToProductDetails(context, product.productId);
        },
      ),
    );
  }

  void _navigateToShopDetails(BuildContext context, String shopId) {
    // Navigate to the shop details page
    // pass the shopId to the details page to fetch and display the details of the specific shop
    /*Navigator.of(context).pushNamed(
      AppRoutes.shopDetails,
      arguments: shopId,
    );*/
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
