import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/profile/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../widgets/bottom_navigation_bar.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.blue.shade800 : Colors.white;
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
              const SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/background.jpeg'),
                ),
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
                        ProfileWidget(
                          title: 'Register your shop',
                          icon: LineAwesomeIcons.user_friends,
                          onPress: () {
                            Navigator.pushReplacementNamed(
                                context, shopRegister);
                          },
                          textColor: textColor,
                        ),

                        //shop dashboard (for user who already registered shops)
                        ProfileWidget(
                          title: 'Shop Dashboard',
                          icon: LineAwesomeIcons.store,
                          onPress: () {
                            Navigator.pushReplacementNamed(
                                context, shopDashboard);
                          },
                          textColor: textColor,
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
                            await SignOut.signOut(context);
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

class SignOut {
  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, login);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.blue.shade800;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 18.0,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color:
                    const Color.fromARGB(255, 155, 234, 248).withOpacity(0.3),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 10.0, color: Color.fromARGB(255, 0, 29, 73)),
            )
          : null,
    );
  }
}
