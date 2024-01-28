import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/presentation/components/shipment_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipments_tab.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips.dart';

import 'bottom_nav_icon.dart';

// ... (imports remain the same)

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

// class HomeScreen extends StatefulWidget {
//   static const routeName = 'Home';
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late TabController tabController;
//   int selectedTab = 0;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//     tabController.addListener(() {
//       setState(() {
//         selectedTab = tabController.index;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 235,
//             floating: true,
//             pinned: true,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.height * .05),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(
//                                 right: MediaQuery.of(context).size.width * .23),
//                             child: Center(
//                               child: Text(
//                                 'Hatly',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 35,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               Icons.search,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             onPressed: () {},
//                           )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(top: 25),
//                       width: MediaQuery.of(context).size.width * 0.7,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         color: Colors.white54,
//                       ),
//                       child: Column(
//                         children: [
//                           TabBar(
//                             controller: tabController,
//                             indicatorColor: Colors.white,
//                             indicatorWeight: 2,
//                             unselectedLabelStyle: GoogleFonts.poppins(
//                                 fontSize: 12, fontWeight: FontWeight.w600),
//                             labelStyle: GoogleFonts.poppins(
//                                 fontSize: 13, fontWeight: FontWeight.bold),
//                             labelColor: Colors.black,
//                             indicator: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             onTap: (index) {
//                               selectedTab = index;
//                               print('index $index');
//                               setState(() {});
//                             },
//                             tabs: [
//                               Tab(
//                                 child: Text('Shipments'),
//                               ),
//                               Tab(
//                                 text: 'Trips',
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.height * 0.04),
//                       child: selectedTab == 0
//                           ? FittedBox(
//                               fit: BoxFit.fitWidth,
//                               child: Text(
//                                 'Browse the available shipments',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             )
//                           : FittedBox(
//                               fit: BoxFit.fitWidth,
//                               child: Text(
//                                 'Browse the available trips',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) => ShipmentCard(),
//               childCount: 10,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// /*   @override
//   Widget build(BuildContext context) {
//     const title = 'Floating App Bar';

//     return MaterialApp(
//       title: title,
//       home: Scaffold(
//         // No appbar provided to the Scaffold, only a body with a
//         // CustomScrollView.
//         body: CustomScrollView(
//           slivers: [
//             // Add the app bar to the CustomScrollView.
//             const SliverAppBar(
//               // Provide a standard title.
//               title: Text(title),
//               // Allows the user to reveal the app bar if they begin scrolling
//               // back up the list of items.
//               floating: true,
//               // Display a placeholder widget to visualize the shrinking size.
//               flexibleSpace: Placeholder(),
//               // Make the initial height of the SliverAppBar larger than normal.
//               expandedHeight: 200,
//             ),
//             // Next, create a SliverList
//             SliverList(
//               // Use a delegate to build items as they're scrolled on screen.
//               delegate: SliverChildBuilderDelegate(
//                 // The builder function returns a ListTile with a title that
//                 // displays the index of the current item.
//                 (context, index) => ListTile(title: Text('Item #$index')),
//                 // Builds 1000 ListTiles
//                 childCount: 1000,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// */
