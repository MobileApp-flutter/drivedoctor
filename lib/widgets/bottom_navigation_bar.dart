import 'package:drivedoctor/bloc/controller/cartController.dart';
import 'package:drivedoctor/screens/cart.dart';
import 'package:drivedoctor/screens/order/orderpage.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/screens/dashboard/dashboard.dart';
import 'package:drivedoctor/screens/dashboard/marketdashboard.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int currentIndex;
  final CartController? cartController;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.cartController,
  });

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  CartController? cartControl = CartController();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Marketplace',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.shipping_fast),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) => onTabTapped(index, context),
      currentIndex: widget.currentIndex,
    );
  }

  void onTabTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        // Navigate to Home page (DashboardPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        // Navigate to Cart page (CartPage)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartPage(
                    cartController: widget.cartController,
                  )),
        );
        break;
      case 2:
        // Navigate to Marketplace page (MarketDashboardPage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MarketDashboardPage(cartController: widget.cartController),
          ),
        );
        break;
      case 3:
        // Navigate to Order page (OrderPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Orderpage()),
        );
        break;
      case 4:
        // Navigate to Profile page (Profile)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
        break;
      default:
        break;
    }
  }
}
