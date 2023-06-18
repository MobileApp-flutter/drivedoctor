import 'package:drivedoctor/bloc/routes/multiplearguments.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/screens/admin/manageusercontent.dart';
import 'package:drivedoctor/screens/carservices/servicedetails.dart';
import 'package:drivedoctor/screens/dashboard/admindashboard.dart';
import 'package:drivedoctor/screens/dashboard/dashboard.dart';
import 'package:drivedoctor/screens/dashboard/shopdashboard.dart';
import 'package:drivedoctor/screens/login/login.dart';
import 'package:drivedoctor/screens/management/manageorder.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:drivedoctor/screens/profile/shop_profile.dart';
import 'package:drivedoctor/screens/register/registrationpage.dart';
import 'package:drivedoctor/screens/register/shopregisterpage.dart';
import 'package:drivedoctor/screens/register/servicesregistration.dart';
import 'package:drivedoctor/screens/shop/shopdetails.dart';
import 'package:drivedoctor/screens/shop/edit_service.dart';
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
    case shopProfile:
      return MaterialPageRoute(builder: (context) => const ShopProfile());
    case shopDetail:
      final shopId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => Shopdetails(
                shopId: shopId,
              ));
    case addService:
      return MaterialPageRoute(builder: (context) => Services());
    case serviceDetail:
      final args = settings.arguments as ShopServiceArguments;
      final serviceId = args.serviceId;
      final shopId = args.shopId;
      return MaterialPageRoute(
        builder: (context) => Servicedetails(
          serviceId: serviceId,
          shopId: shopId,
        ),
      );
    case adminDashboard:
      return MaterialPageRoute(builder: (context) => const Admindashboard());
    case manageUser:
      return MaterialPageRoute(builder: (context) => const Manageusercontent());
    case manageOrder:
      return MaterialPageRoute(builder: (context) => const Manageorder());
    case serviceEdit:
      final serviceId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => Serviceedit(serviceId: serviceId));
  }
  return null;
}
