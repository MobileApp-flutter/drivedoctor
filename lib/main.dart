import 'package:drivedoctor/bloc/routes/createroute.dart';
import 'package:drivedoctor/screens/dashboard/admindashboard.dart';
import 'package:drivedoctor/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:drivedoctor/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/dashboard/dashboard.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(), // Initialize the UserProvider
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthChecker(),
        onGenerateRoute: createRoute,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class AuthChecker extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return FutureBuilder<bool>(
          future: _checkOnboardingCompleted(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == false) {
                final User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  userProvider.setUserId("null");
                  userProvider.setUserEmail("null");
                  return const LoginPage();
                } else {
                  // Check if the user is an admin or a regular user
                  if (user.email == "admin@example.com") {
                    userProvider.setUserId(user.uid);
                    userProvider.setUserEmail(user.email!);
                    return const Admindashboard();
                  } else {
                    userProvider.setUserId(user.uid);
                    userProvider.setUserEmail(user.email!);
                    return const DashboardPage();
                  }
                }
              } else {
                return Onboarding(
                  onComplete: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Admindashboard()),
                    );
                  },
                );
              }
            } else {
              return const SplashScreen();
            }
          },
        );
      },
    );
  }

  Future<bool> _checkOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }
}
