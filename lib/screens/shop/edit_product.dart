import 'dart:io';

import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/services/productservice.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:permission_handler/permission_handler.dart';

class Productedit extends StatefulWidget {
  final String productId;

  const Productedit({Key? key, required this.productId}) : super(key: key);

  @override
  State<Productedit> createState() => _ProducteditState();
}

class _ProducteditState extends State<Productedit> {
  String? _productName;
  double? _price;
  String? _description;
  int? _stock;
  String? shopID;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();

  //list of images
  final Storage storage = Storage();
  final ProductsService productsService = ProductsService();
  List<File> selectedImages = [];

  void _editProduct() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        // Upload the images to Firebase storage
        await storage.uploadImages(selectedImages, widget.productId, false);
        await productsService.updateProduct(
          productId: widget.productId,
          productName: _productName,
          price: _price,
          stock: _stock,
          description: _description,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product Updated!')));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, shopDashboard);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating product')),
        );
      }
    }
  }

  void _deleteProduct() async {
    try {
      // Delete the product from Firebase storage
      await storage.deleteAllImages(widget.productId, false);
      await productsService.deleteProduct(widget.productId);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Deleted!')));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context,
          shopDashboard); // Return to the previous screen after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting Product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, shopDashboard);
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text("Edit Product", style: defaultText),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Select multiple images
                    PermissionStatus status =
                        await Permission.manageExternalStorage.request();
                    if (status.isGranted) {
                      // Select multiple images
                      await storage.selectImages(selectedImages);

                      setState(() {});
                    } else {
                      // Request permission to access external storage
                      if (await Permission.storage.request().isGranted) {
                        // Permission granted, select multiple images
                        await storage.selectImages(selectedImages);

                        setState(() {});
                      } else {
                        // Permission denied, show a message or handle the error
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Permission denied to access external storage.'),
                          ),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade800,
                    ),
                  ),
                  child: const Text('Select Images'),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Image.file(selectedImages[index]),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Currently Stored Images:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<String>>(
                  future: storage.fetchImages(widget.productId,
                      false), // Retrieve currently stored images
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<String> storedImages = snapshot.data ?? [];

                      if (storedImages.isEmpty) {
                        return const Text('No images currently stored.');
                      }

                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Image.network(storedImages[index]),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        storedImages.removeAt(index);
                                      });

                                      // Delete the image from Firebase storage
                                      storage.deleteImage(
                                          widget.productId, false, index);
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                TextFormField(
                  controller: textform.serviceNameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _productName = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.servicePriceController,
                  decoration: const InputDecoration(
                    labelText: "Product Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    if (value != null) {
                      _price = double.tryParse(value) ?? 0.0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.waitTimeController,
                  decoration: const InputDecoration(
                    labelText: "Stock",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    if (value != null) {
                      _stock = int.tryParse(value) ?? 0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.serviceDescController,
                  decoration: const InputDecoration(
                    labelText: "Product Description",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _editProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Update Product',
                      style: defaultText,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _deleteProduct, // Add the delete function here
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Use a red color for the delete button
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Delete Product',
                      style: defaultText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
