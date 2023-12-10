import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/ui/home/tabs/home/home_tab_viewmodel.dart';
import 'package:hive/hive.dart';

import '../../../../domain/models/shipment_dto.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../components/shipment_card.dart';

class HomeTab extends StatefulWidget {
  static const routeName = 'Home';
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late TabController tabController;
  bool shipmentsIsEmpty = false;
  int selectedTab = 0;
  List<ShipmentDto> shipments = [];

  HomeScreenViewModel viewModel = HomeScreenViewModel();
  @override
  void initState() {
    late String token;

    super.initState();
    // Check for cached shipments when initializing
    Future.delayed(Duration(milliseconds: 300), () {
      getCachedShipments().then((cachedShipments) {
        if (cachedShipments.isNotEmpty) {
          print('exist');
          setState(() {
            shipments = cachedShipments;
          });
        } else {
          viewModel.create(); // Fetch from API if cache is empty
        }
      });
    });
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.token;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedTab = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // a method for caching the shipments list
  Future<void> cacheShipments(List<ShipmentDto> shipments) async {
    final box = await Hive.openBox('shipments');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final shipmentMaps =
        shipments.map((shipment) => shipment.toJson()).toList();

    // Clear existing data and store the new data in the box
    await box.clear();
    await box.addAll(shipmentMaps);
  }

  Future<List<ShipmentDto>> getCachedShipments() async {
    final box = await Hive.openBox('shipments');
    final shipmentMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final shipments = shipmentMaps
        .map((shipmentMap) => ShipmentDto.fromJson(shipmentMap))
        .toList();

    return shipments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is GetAllShipsLoadingState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Loading',
                alertContent: state.loadingMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Loading',
                alertContent: state.loadingMessage,
                context: context);
          }
        } else if (state is GetAllShipsFailState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Fail',
                alertContent: state.failMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Fail',
                alertContent: state.failMessage,
                context: context);
          }
        }
      },
      listenWhen: (previous, current) {
        if (previous is GetAllShipsLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is GetAllShipsLoadingState ||
            current is GetAllShipsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetAllShipsSuccessState) {
          shipments = state.responseDto.shipments!;
          if (shipments.isEmpty) {
            shipmentsIsEmpty = true;
            print("emptyyyy");
          } else {
            shipmentsIsEmpty = false;
            cacheShipments(shipments);
            print('success ${shipments[0].items![0].photo}');
          }
        }
        return RefreshIndicator(
          onRefresh: () async {
            await viewModel.create();
            cacheShipments(shipments);
            setState(() {});
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * .244,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .05),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Hatly',
                                        style: GoogleFonts.poppins(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white54,
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: tabController,
                                  indicatorColor: Colors.white,
                                  indicatorWeight: 2,
                                  unselectedLabelStyle: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                  labelStyle: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  labelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onTap: (index) {
                                    selectedTab = index;
                                    print('index $index');
                                    setState(() {});
                                  },
                                  tabs: [
                                    Tab(
                                      child: Text('Shipments'),
                                    ),
                                    Tab(
                                      text: 'Trips',
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: selectedTab == 0
                                ? FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Browse the available shipments',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Browse the available trips',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                shipmentsIsEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(
                                'images/no_all_shipments.png',
                                width: 350,
                                height: 330,
                              ),
                            ),
                            Container(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "There are not any shipments\n right now!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => selectedTab == 0
                              ? ShipmentCard(
                                  title: shipments[index].title!,
                                  from: shipments[index].from!,
                                  to: shipments[index].to!,
                                  date: shipments[index].expectedDate!,
                                  userName: shipments[index].user!.name!,
                                  shipImage: shipments[index].items![0].photo ==
                                          null
                                      ? null
                                      : base64ToImage(
                                          shipments[index].items![0].photo!),
                                  userImage: shipments[index]
                                              .user!
                                              .profilePhoto ==
                                          null
                                      ? null
                                      : base64ToUserImage(
                                          shipments[index].user!.profilePhoto!),
                                  bonus: shipments[index].reward.toString(),
                                )
                              : Container(),
                          childCount: shipments.length,
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

Image base64ToImage(String base64String) {
  Uint8List bytes = base64.decode(base64String);
  return Image.memory(
    bytes,
    fit: BoxFit.fitHeight,
    width: 100,
    height: 100,
  );
}

Image base64ToUserImage(String base64String) {
  Uint8List bytes = base64.decode(base64String);
  return Image.memory(
    bytes,
    fit: BoxFit.cover,
    width: 50,
    height: 50,
  );
}
  
/*   @override
  Widget build(BuildContext context) {
    const title = 'Floating App Bar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            const SliverAppBar(
              // Provide a standard title.
              title: Text(title),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
            ),
            // Next, create a SliverList
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
