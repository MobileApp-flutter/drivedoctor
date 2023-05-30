import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/bloc/services/userservice.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? id;
  String? _username;
  String? _fullname;
  String? _password;
  int? _contact;
  String? email;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();
  bool _passwordVisible = false;

  int _countOfReload = 0;

  @override
  void initState() {
    super.initState();
    startAutoReload();
  }

  void startAutoReload() {
    setState(() {
      _countOfReload++;
    });
  }

  void _updateForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await updateUser(
            id: currentUser.uid,
            username: _username,
            fullname: _fullname,
            contact: _contact,
            password: _password,
            email: Auth.email,
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Profile Updated!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not logged in')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    String imageName = 'profile.jpg';

    void onRefresh() {
      // Refresh the data.
      storage.fetchProfilePicture(imageName);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: const Text("Edit Profile", style: defaultText),
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
                                      : const AssetImage('assets/user.png');

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
                                  const fileName = 'profile.jpg';

                                  // Check if the selected file is a JPG
                                  if (path!.endsWith('.jpg')) {
                                    await storage.uploadProfilePicture(
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

                                  onRefresh();
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
                  const SizedBox(height: 50),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FutureBuilder<UserData>(
                            future: Auth.getUserDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<UserData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String username = snapshot.hasData
                                    ? snapshot.data!.username
                                    : 'Guest';

                                return TextFormField(
                                  controller: textform.usernameController,
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    hintText: username,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _username = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<UserData>(
                            future: Auth.getUserDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<UserData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String fullname = snapshot.hasData
                                    ? snapshot.data!.fullname
                                    : 'Guest';

                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Fullname",
                                    hintText: fullname,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.user_check),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _fullname = value;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: const Icon(LineAwesomeIcons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: !_passwordVisible,
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<UserData>(
                            future: Auth.getUserDataByEmail(Auth.email),
                            builder: (BuildContext context,
                                AsyncSnapshot<UserData> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for the future to resolve
                                return const CircularProgressIndicator();
                              } else {
                                String contact = snapshot.hasData
                                    ? snapshot.data!.contact.toString()
                                    : 'Guest';

                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Contact",
                                    hintText: contact,
                                    prefixIcon:
                                        const Icon(LineAwesomeIcons.phone),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      _contact = int.parse(value);
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: _updateForm,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade800,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  child: const Text('Update profile',
                                      style: defaultText)))
                        ],
                      ))
                ]))));
  }
}
