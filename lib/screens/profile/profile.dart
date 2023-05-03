import 'package:drivedoctor/constants/textstyle.dart';
import 'package:drivedoctor/screens/profile/update_profile.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../constants/bottom_navigation_bar.dart';

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
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: Center(
            child: Text(
              'Profile',
              style: defaultText.copyWith(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                color: iconColor,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex:
              0, // Replace with your current index variable// Replace with your onTabTapped callback function
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
              Text(
                'John Wick',
                style: defaultText.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateProfile()),
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
              const SizedBox(height: 15),
              Divider(
                color: Colors.blue.shade800,
              ),
              const SizedBox(height: 10),
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
                title: 'User Management',
                icon: LineAwesomeIcons.user_check,
                onPress: () {},
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
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
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
