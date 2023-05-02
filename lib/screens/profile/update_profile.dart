import 'package:drivedoctor/constants/textstyle.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                      child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Username",
                          hintText: "Enter your username",
                          prefixIcon: Icon(LineAwesomeIcons.user),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: Icon(LineAwesomeIcons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: Icon(LineAwesomeIcons.envelope),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Profile()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text('Update changes',
                                  style: defaultText)))
                    ],
                  ))
                ]))));
  }
}
