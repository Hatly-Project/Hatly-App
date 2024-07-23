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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add new shipment',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 20, color: Color(0xFF5A5A5A)),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Color(0xFF5A5A5A),
                      )
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 1,
                  color: Color(0xFFD6D6D6),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add new trip',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 20, color: Color(0xFF5A5A5A)),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Color(0xFF5A5A5A),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
