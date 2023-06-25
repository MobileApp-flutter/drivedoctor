import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/servicesservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class Services extends StatefulWidget {
  Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final _formKey = GlobalKey<FormState>();

  String _servicename = '';

  String _serviceprice = '';

  String _waittime = '';

  String _servicedesc = '';

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
      final serviceDoc =
          FirebaseFirestore.instance.collection('services').doc();
      final serviceId = serviceDoc.id;

      final shopDoc = shopQuerySnapshot.docs.first.reference;
      final shopId = shopDoc.id;

      try {
        //upload the images to Firebase storage
        await storage.uploadImages(selectedImages, serviceId);

        //create the service
        await createService(
          serviceId: serviceId,
          servicename: _servicename,
          serviceprice: _serviceprice,
          waittime: _waittime,
          servicedesc: _servicedesc,
          shopId: shopId, //add the shopId parameter
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service Added')),
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
        title: const Text('Register Service'),
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
                              labelText: 'Service Name',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the service name';
                              }
                              return null;
                            },
                            onSaved: (value) => _servicename = value!,
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
                              labelText: 'Starting Price',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the starting price';
                              }
                              return null;
                            },
                            onSaved: (value) => _serviceprice = value!,
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
                              labelText: 'Expected Waiting Time',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the expected waiting time';
                              }
                              return null;
                            },
                            onSaved: (value) => _waittime = value!,
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
                              labelText: 'Service description',
                              labelStyle:
                                  TextStyle(color: Colors.blue.shade800),
                            ),
                            maxLines:
                                null, // Allows the text field to expand to multiple lines
                            keyboardType: TextInputType
                                .multiline, // Enables multiline input
                            onChanged: (value) {
                              _servicedesc = value;
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
                      child: const Text('Add Service'),
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
