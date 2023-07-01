import 'dart:io';

import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/bloc/services/servicesservice.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:permission_handler/permission_handler.dart';

class Serviceedit extends StatefulWidget {
  final String serviceId;

  const Serviceedit({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<Serviceedit> createState() => _ServiceeditState();
}

class _ServiceeditState extends State<Serviceedit> {
  String? _servicename;
  String? _serviceprice;
  String? _waittime;
  String? _servicedesc;
  String? shopID;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();

  //list of images
  final Storage storage = Storage();
  List<File> selectedImages = [];

  void _editService() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      try {
        //upload the images to Firebase storage
        await storage.uploadImages(selectedImages, widget.serviceId, true);
        await updateService(
          serviceId: widget.serviceId,
          servicename: _servicename,
          serviceprice: _serviceprice,
          waittime: _waittime,
          servicedesc: _servicedesc,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Service Updated!')));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, shopDashboard);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating service')),
        );
      }
    }
  }

  void _deleteService() async {
    try {
      // Delete the service from Firebase storage
      await storage.deleteAllImages(widget.serviceId, true);
      await deleteService(serviceId: widget.serviceId);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Service Deleted!')));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context,
          shopDashboard); // Return to the previous screen after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting service')),
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
        title: const Text("Edit Service", style: defaultText),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //display current images and option to change image
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
                      const SizedBox(height: 10),
                      const Text(
                        'Currently Stored Images:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<List<String>>(
                        future: storage.fetchImages(widget.serviceId,
                            true), // Retrieve currently stored images
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                        child:
                                            Image.network(storedImages[index]),
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
                                                widget.serviceId, true, index);
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
                    ],
                  ),
                ),

                TextFormField(
                  controller: textform.serviceNameController,
                  decoration: const InputDecoration(
                    labelText: "Service Name",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _servicename = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.servicePriceController,
                  decoration: const InputDecoration(
                    labelText: "Service Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _serviceprice = value;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.waitTimeController,
                  decoration: const InputDecoration(
                    labelText: "Wait Time",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _waittime = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.serviceDescController,
                  decoration: const InputDecoration(
                    labelText: "Service Description",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _servicedesc = value;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _editService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Update Service',
                      style: defaultText,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _deleteService, // Add the delete function here
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Use a red color for the delete button
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Delete Service',
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
