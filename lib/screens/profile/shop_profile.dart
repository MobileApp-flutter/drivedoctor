import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/shopservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ShopProfile extends StatefulWidget {
  const ShopProfile({Key? key}) : super(key: key);

  @override
  State<ShopProfile> createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  String? _shopname;
  String? _companyname;
  String? _companycontact;
  String? _companyemail;
  String? _address;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();

  void _updateShop() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        //get shop id from database
        final shopDoc = await FirebaseFirestore.instance
            .collection('shops')
            .where("email", isEqualTo: Auth.currentUser?.email)
            .get();

        final email = shopDoc.docs.first.data()['email'];

        //update shop profile
        await updateShop(
          // shopId: shopId,
          shopname: _shopname!,
          companyname: _companyname!,
          companycontact: _companycontact!,
          companyemail: _companyemail!,
          address: _address!,
          owneremail: email!,
        );

        //message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile Updated!')));

        //navigate to shop dashboard
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, shopDashboard);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error $context')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    String imageName = 'shop.jpg';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, shopDashboard);
              },
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: const Text("Edit shop profile", style: defaultText),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            FutureBuilder<String>(
                              future: storage.fetchProfilePicture(imageName),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the future to resolve
                                  return const CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasError) {
                                    // Error occurred while fetching the download URL
                                    print(snapshot.error);
                                  }

                                  String downloadUrl =
                                      snapshot.data?.toString() ?? '';
                                  final imageProvider = downloadUrl.isNotEmpty
                                      ? NetworkImage(downloadUrl)
                                          as ImageProvider
                                      : const AssetImage(
                                          'assets/shop_image.jpg');

                                  return CircleAvatar(
                                    radius: 70,
                                    backgroundImage: imageProvider,
                                  );
                                }
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final results =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                    allowMultiple: false,
                                  );

                                  if (results == null) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No File selected.'),
                                      ),
                                    );

                                    return;
                                  }

                                  final path = results.files.single.path;
                                  const fileName = 'shop.jpg';

                                  // Check if the selected file is a JPG
                                  if (path!.endsWith('.jpg')) {
                                    await storage.uploadShopProfilePic(
                                        path, fileName);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please select a JPG image.'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 25,
                                ),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FutureBuilder<ShopData>(
                            future: Auth.getShopDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ShopData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String shopname = snapshot.hasData
                                    ? snapshot.data!.shopname
                                    : 'No shop name';

                                return TextFormField(
                                  controller: textform.shopnameController,
                                  decoration: InputDecoration(
                                    labelText: "Shop name",
                                    hintText: shopname,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _shopname = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<ShopData>(
                            future: Auth.getShopDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ShopData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String companyname = snapshot.hasData
                                    ? snapshot.data!.companyname
                                    : 'No company name';

                                return TextFormField(
                                  controller: textform.companynameController,
                                  decoration: InputDecoration(
                                    labelText: "Company name",
                                    hintText: companyname,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _companyname = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<ShopData>(
                            future: Auth.getShopDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ShopData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String companycontact = snapshot.hasData
                                    ? snapshot.data!.companycontact
                                    : 'No company contact';

                                return TextFormField(
                                  controller: textform.companycontactController,
                                  decoration: InputDecoration(
                                    labelText: "Company contact",
                                    hintText: companycontact,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _companycontact = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<ShopData>(
                            future: Auth.getShopDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ShopData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String companyemail = snapshot.hasData
                                    ? snapshot.data!.companyemail
                                    : 'No company email';

                                return TextFormField(
                                  controller: textform.companyemailController,
                                  decoration: InputDecoration(
                                    labelText: "Company email",
                                    hintText: companyemail,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _companyemail = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<ShopData>(
                            future: Auth.getShopDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ShopData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String companyadress = snapshot.hasData
                                    ? snapshot.data!.address
                                    : 'No company address';

                                return TextFormField(
                                  controller: textform.addressController,
                                  decoration: InputDecoration(
                                    labelText: "Company address",
                                    hintText: companyadress,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _address = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: _updateShop,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade800,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  child: const Text('Update shop',
                                      style: defaultText)))
                        ],
                      ))
                ]))));
  }
}
