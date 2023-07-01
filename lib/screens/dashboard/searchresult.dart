import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import '../../bloc/models/shop.dart';
import '../../bloc/models/product.dart';

class SearchResultsPage extends StatefulWidget {
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
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final Storage storage = Storage();
  String imageName = 'shop.jpg';

  @override
  Widget build(BuildContext context) {
    List<dynamic> results;
    if (widget.searchOption == 'all') {
      results = [...widget.shops, ...widget.products];
    } else if (widget.searchOption == 'shop') {
      results = widget.shops;
    } else if (widget.searchOption == 'product') {
      results = widget.products;
    } else {
      results = <dynamic>[];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results - ${widget.searchOption}'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView.separated(
        itemCount: results.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.blue.shade800, // Set the color of the divider here
          height: 1, // Set the height of the divider here
        ),
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
      height: 100,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: FutureBuilder<String>(
              future: storage.fetchShopProfilePicture(shop.shopId, imageName),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Image.network(
                    shop.imageUrl,
                    height: 120.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  );
                } else {
                  String downloadUrl = snapshot.data?.toString() ?? '';
                  final imageProvider = downloadUrl.isNotEmpty
                      ? NetworkImage(downloadUrl) as ImageProvider
                      : const AssetImage('assets/shop_image.jpg');

                  return Image(
                    image: imageProvider,
                    height: 120.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  );
                }
              }),
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
          Navigator.pushReplacementNamed(context, shopDetail,
              arguments: shop.shopId);
        },
      ),
    );
  }

  Widget _buildProductItem(ProductData product, BuildContext context) {
    return SizedBox(
      height: 100, // Adjust the height as desired
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: SizedBox(
            height: 120.0,
            width: 200.0,
            child: FutureBuilder<List<String>>(
              future: storage.fetchImages(product.productId, false),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
