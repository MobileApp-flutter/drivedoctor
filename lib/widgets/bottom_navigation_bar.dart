import 'package:drivedoctor/screens/order/orderpage.dart';
import 'package:drivedoctor/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:drivedoctor/screens/dashboard/dashboard.dart';
import 'package:drivedoctor/screens/dashboard/marketdashboard.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
  });

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
      currentIndex: currentIndex,
    );
  }

  void onTabTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        // Navigate to Home page (DashboardPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 1:
        // Navigate to Cart page (CartPage)
        break;
      case 2:
        // Navigate to Marketplace page (MarketDashboardPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketDashboardPage()),
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
