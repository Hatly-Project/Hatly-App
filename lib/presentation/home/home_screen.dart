import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/my_theme.dart';
import 'package:hatly/presentation/components/shipment_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab.dart';
import 'package:hatly/presentation/home/tabs/profile/profile_tab.dart';
import 'package:hatly/presentation/home/tabs/shipments/add_shipment/add_shipment_screen.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
        body: tabs[selectedIndex],
        bottomNavigationBar: NavigationBar(
          height: 70,
          animationDuration: Duration(milliseconds: 1000),
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            if (value == 2) {
              isAddSelected = true;
              _showBottomSheet(context);
            } else {
              selectedIndex = value;
              isAddSelected = false;
            }
            setState(() {});
          },
          destinations: [
            const NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/home.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
                color: Color(0xFFADADAD),
              ),
              selectedIcon: ImageIcon(
                AssetImage('images/home.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
              ),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/fast.png'),
                // size: 25,
                color: Color(0xFFADADAD),
              ),
              selectedIcon: ImageIcon(
                AssetImage('images/fast.png'),
                // size: 25,
                // color: Color(0xFFADADAD),
              ),
              label: 'Shipments',
            ),
            InkWell(
              onTap: () {
                _showBottomSheet(context);
              },
              child: BottomNavIcon('add', selectedIndex == 2),
            ),
            const NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/airplane.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
                color: Color(0xFFADADAD),
              ),
              selectedIcon: ImageIcon(
                AssetImage('images/airplane.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
              ),
              label: 'Trips',
            ),
            const NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/profile.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
                color: Color(0xFFADADAD),
              ),
              selectedIcon: ImageIcon(
                AssetImage('images/profile.png'),
                // size: 25,
                // color: Theme.of(context).primaryColor,
                // color: Color(0xFFADADAD),
              ),
              label: 'Profile',
            ),
          ],
        ));
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
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AddShipmentScreen.routeName,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add new shipment',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 20, color: Color(0xFF5A5A5A)),
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
