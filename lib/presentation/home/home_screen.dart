import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/presentation/components/shipment_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipments_tab.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips.dart';
import 'bottom_nav_icon.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;
  var isSelected = false;
  var tabs = [HomeTab(), MyShipmentsTab(), MyTripsTab()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // iconSize: 10,
        enableFeedback: true,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: selectedIndex,
        elevation: 0,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('home', selectedIndex == 0),
              label: 'Home'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('fast', selectedIndex == 1),
              label: 'My Shipments'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('airplane', selectedIndex == 2),
              label: 'My Trips'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('profile', selectedIndex == 3),
              label: ''),
        ],
      ),
    );
  }
}
