import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/my_theme.dart';
import 'package:hatly/presentation/components/shipment_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab.dart';
import 'package:hatly/presentation/home/tabs/profile/profile_tab.dart';
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
  var isSelected = false, isAddSelected = false;
  var tabs = [HomeTab(), MyShipmentsTab(), MyTripsTab(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        enableFeedback: true,
        // backgroundColor: Colors.transparent,
        currentIndex: selectedIndex,
        // selectedFontSize: 5,
        // unselectedFontSize: 15,
        selectedLabelStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 13.5,
            ),
        selectedItemColor: Theme.of(context).textTheme.displayLarge?.color,
        unselectedLabelStyle:
            Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 12.5,
                ),
        unselectedItemColor: MyTheme.disabledTextButtonColor,
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (index) {
          if (index == 2) {
            isAddSelected = true;
            _showBottomSheet(context);
          } else {
            selectedIndex = index;
            isAddSelected = false;
          }
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: BottomNavIcon('home', selectedIndex == 0),
              label: 'Home'),
          BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: BottomNavIcon('fast', selectedIndex == 1),
              label: 'My Shipments'),
          BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: BottomNavIcon('add', selectedIndex == 2),
              label: ''),
          BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: BottomNavIcon('airplane', selectedIndex == 3),
              label: 'My Trips'),
          BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: BottomNavIcon('profile', selectedIndex == 4),
              label: 'Profile'),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Option 1'),
                onTap: () {
                  // Handle option 1 action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Option 2'),
                onTap: () {
                  // Handle option 2 action
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
