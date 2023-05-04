import 'package:drivedoctor/routes/route.dart';
import 'package:drivedoctor/screens/dashboard/dashboard.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:flutter/material.dart';

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case login:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case dashboard:
      return MaterialPageRoute(builder: (context) => DashboardPage());
    case profile:
      return MaterialPageRoute(builder: (context) => const Profile());
  }
  return null;
}
