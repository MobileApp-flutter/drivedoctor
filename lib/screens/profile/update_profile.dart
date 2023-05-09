import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:drivedoctor/bloc/services/userservice.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/background.jpeg'),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.blue.shade800,
                            ),
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              color: Colors.white,
                              size: 20,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 50),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: textform.usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              hintText: "Enter your username",
                              prefixIcon: Icon(LineAwesomeIcons.user),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _username = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Fullname",
                              hintText: "Enter your fullname",
                              prefixIcon: Icon(LineAwesomeIcons.user_check),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _fullname = value;
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
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Contact",
                              hintText: "Enter your contact",
                              prefixIcon: Icon(LineAwesomeIcons.phone),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                _contact = int.parse(value);
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
