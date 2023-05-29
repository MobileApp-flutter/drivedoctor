import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/admin/manageusercontent.dart';
import 'package:drivedoctor/screens/dashboard/admindashboard.dart';
import 'package:drivedoctor/screens/dashboard/dashboard.dart';
import 'package:drivedoctor/screens/dashboard/shopdashboard.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:drivedoctor/screens/registrationpage.dart';
import 'package:drivedoctor/screens/shopregisterpage.dart';
import 'package:drivedoctor/screens/services/services.dart';
import 'package:flutter/material.dart';

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case login:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case dashboard:
      return MaterialPageRoute(builder: (context) => const DashboardPage());
    case profile:
      return MaterialPageRoute(builder: (context) => const Profile());
    case userRegister:
      return MaterialPageRoute(builder: (context) => const RegistrationPage());
    case shopRegister:
      return MaterialPageRoute(builder: (context) => const ShopResgisterPage());
    case shopDashboard:
      return MaterialPageRoute(builder: (context) => const Shopdashboard());
  case addService:
      return MaterialPageRoute(builder: (context) => Services());
    case adminDashboard:
      return MaterialPageRoute(builder: (context) => const Admindashboard());
    case manageUser:
      return MaterialPageRoute(builder: (context) => const Manageusercontent());
  }
  return null;
}
