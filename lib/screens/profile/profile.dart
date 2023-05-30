import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/shop.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/authservice.dart';
import 'package:drivedoctor/bloc/services/shopservice.dart';
import 'package:drivedoctor/bloc/services/storageservice.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/profile/update_profile.dart';
import 'package:drivedoctor/widgets/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../widgets/bottom_navigation_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Storage storage = Storage();
  String imageName = 'profile.jpg';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : null;

    return Theme(
      data: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade800,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex:
              4, // Replace with your current index variable// Replace with your onTabTapped callback function
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: storage.fetchProfilePicture(imageName),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the future to resolve
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      // Error occurred while fetching the download URL
                      print(snapshot.error);
                    }

                    String downloadUrl = snapshot.data?.toString() ?? '';
                    final imageProvider = downloadUrl.isNotEmpty
                        ? NetworkImage(downloadUrl) as ImageProvider
                        : const AssetImage('assets/user.png');

                    return CircleAvatar(
                      radius: 70,
                      backgroundImage: imageProvider,
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<UserData>(
                future: Auth.getUserDataByEmail(
                    Auth.email), // pass email as argument
                builder: (context, snapshot) {
                  final username = snapshot.data?.username;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    // check if snapshot has data
                    return const Text('Guest');
                  } else {
                    return Text(
                      '$username',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: FirebaseAuth.instance.currentUser != null,
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateProfile(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: FirebaseAuth.instance.currentUser == null,
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.blue.shade800,
              ),
              const SizedBox(height: 10),

              // Display the profile widgets only if the user is logged in
              Auth.currentUser != null
                  ? Column(
                      children: [
                        ProfileWidget(
                          title: 'Settings',
                          icon: LineAwesomeIcons.cog,
                          onPress: () {},
                          textColor: textColor,
                        ),
                        ProfileWidget(
                          title: 'Billing Details',
                          icon: LineAwesomeIcons.wallet,
                          onPress: () {},
                          textColor: textColor,
                        ),

                        //shop option (for user who already registered shops)

                        FutureBuilder<ShopData?>(
                          future: hasShopRegistered(Auth.email),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // return a loading indicator or an empty container
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              // shop exists
                              return ProfileWidget(
                                title: 'Shop Dashboard',
                                icon: LineAwesomeIcons.store,
                                onPress: () {
                                  Navigator.pushReplacementNamed(
                                      context, shopDashboard);
                                },
                                textColor: textColor,
                              );
                            } else {
                              // shop doesn't exist
                              return ProfileWidget(
                                title: 'Register your shop',
                                icon: LineAwesomeIcons.user_friends,
                                onPress: () {
                                  Navigator.pushReplacementNamed(
                                      context, shopRegister);
                                },
                                textColor: textColor,
                              );
                            }
                          },
                        ),

                        Divider(
                          color: Colors.blue.shade800,
                        ),
                        const SizedBox(height: 10),
                        ProfileWidget(
                          title: 'Information',
                          icon: LineAwesomeIcons.info,
                          onPress: () {},
                          textColor: textColor,
                        ),
                        ProfileWidget(
                          title: 'Logout',
                          icon: LineAwesomeIcons.alternate_sign_out,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () async {
                            await signOut(context);
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
