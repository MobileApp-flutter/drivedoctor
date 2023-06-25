import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/productservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget {
  Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _formKey = GlobalKey<FormState>();

  String _productName = '';

  double _price = 0;

  String _description = '';

  int _stock = 0;

  //list of images
  final Storage storage = Storage();
  List<File> selectedImages = [];

  void _submitForm(BuildContext context) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      //get the shopId of the current user
      final shopQuerySnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('email', isEqualTo: Auth.email)
          .get();

      //define service id
      final productDoc =
          FirebaseFirestore.instance.collection('products').doc();
      final productId = productDoc.id;

      final shopDoc = shopQuerySnapshot.docs.first.reference;
      final shopId = shopDoc.id;

      try {
        //upload the images to Firebase storage
        await storage.uploadImages(selectedImages, productId);

        //create the service
        await createProduct(
          productId: productId,
          productName: _productName,
          price: _price,
          description: _description,
          stock: _stock,
          shopId: shopId, //add the shopId parameter
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Added')),
        );

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, shopDashboard);
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, shopDashboard);
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Register Product'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add multiple images and display them without saving to the database
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Select multiple images
                        await storage.selectImages(selectedImages);

                        setState(() {});
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
                  ],
                ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: const [],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Product Name',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the product name';
                              }
                              return null;
                            },
                            onSaved: (value) => _productName = value!,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Price',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                _price = double.parse(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Product Desc',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Product Description';
                              }
                              return null;
                            },
                            onSaved: (value) => _description = value!,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Product Stock',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            maxLines:
                                null, // Allows the text field to expand to multiple lines
                            keyboardType: TextInputType
                                .multiline, // Enables multiline input
                            onChanged: (value) {
                              _stock = int.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade800),
                      ),
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
