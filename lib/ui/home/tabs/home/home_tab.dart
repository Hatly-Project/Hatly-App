import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/ui/components/shimmer_card.dart';
import 'package:hatly/ui/components/trip_card.dart';
import 'package:hatly/ui/home/tabs/home/home_tab_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
  ScrollController scrollController = ScrollController();
  bool shipmentsIsEmpty = false;
  bool tripsIsEmpty = true;
  int selectedTab = 0;
  List<ShipmentDto> shipments = [];
  List<TripsDto> trips = [];
  late String token;
  bool shimmerIsLoading = true;

  HomeScreenViewModel viewModel = HomeScreenViewModel();
  @override
  void initState() {
    super.initState();
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

    // Check for cached shipments when initializing
    Future.delayed(Duration(milliseconds: 400), () {
      getCachedShipments().then((cachedShipments) {
        if (cachedShipments.isNotEmpty) {
          print('exist');
          setState(() {
            shipments = cachedShipments;
            shimmerIsLoading = false;
          });
        } else {
          viewModel.create(token); // Fetch from API if cache is empty
        }
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

  // a method for caching the trips list
  Future<void> cacheTrips(List<TripsDto> trips) async {
    final box = await Hive.openBox('trips');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final tripsMaps = trips.map((trip) => trip.toJson()).toList();

    // Clear existing data and store the new data in the box
    await box.clear();
    await box.addAll(tripsMaps);
  }

  Future<List<TripsDto>> getChachedtrips() async {
    final box = await Hive.openBox('trips');
    final tripsMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final trips =
        tripsMaps.map((tripsMaps) => TripsDto.fromJson(tripsMaps)).toList();

    return trips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is GetAllShipsLoadingState) {
            shimmerIsLoading = true;
            // if (Platform.isIOS) {
            //   DialogUtils.showDialogIos(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // } else {
            //   DialogUtils.showDialogAndroid(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // }
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
          if (state is GetAllTripsLoadingState) {
            shimmerIsLoading = true;
            // ListView.builder(
            //   itemCount: 2,
            //   itemBuilder: (context, index) => const ShimmerCard(),
            // );
            // if (Platform.isIOS) {
            //   DialogUtils.showDialogIos(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // } else {
            //   DialogUtils.showDialogAndroid(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // }
          } else if (state is GetAllTripsFailState) {
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
          if (previous is GetAllShipsLoadingState ||
              previous is GetAllTripsLoadingState) {
            shimmerIsLoading = false;
            // DialogUtils.hideDialog(context);
          }
          if (current is GetAllShipsLoadingState ||
              current is GetAllShipsFailState ||
              current is GetAllTripsLoadingState ||
              current is GetAllTripsFailState) {
            print(current);
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
            shimmerIsLoading = false;
          }
          if (state is GetAllTripsSuccessState) {
            print('tripss');
            trips = state.responseDto.trips!;
            if (trips.isEmpty) {
              tripsIsEmpty = true;
              print('trips empty');
            } else {
              print('tripss success');
              tripsIsEmpty = false;
              cacheTrips(trips);
            }
            shimmerIsLoading = false;
          }
          return Platform.isIOS
              ? CupertinoPageScaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight:
                            MediaQuery.of(context).size.height * .244,
                        floating: false,
                        pinned: true,
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        title: Text(
                          'Hatly',
                          style: GoogleFonts.poppins(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        actions: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    // margin: EdgeInsets.only(right: 20),
                                    ),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.13),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(top: 30),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                                        unselectedLabelStyle:
                                            GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                        labelStyle: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        labelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        onTap: (index) async {
                                          selectedTab = index;
                                          print('index $index');
                                          if (selectedTab == 1) {
                                            getTrips();
                                          } else {
                                            getShipments();
                                          }
                                        },
                                        tabs: const [
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
                                      top: MediaQuery.of(context).size.height *
                                          0.04),
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
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                          if (selectedTab == 0) {
                            final box = await Hive.openBox('shipments');
                            await box.clear();
                            await box.close();
                            await viewModel.create(token);
                          } else {
                            final box = await Hive.openBox('trips');
                            await box.clear();
                            await box.close();
                            await viewModel.getAlltrips(token);
                          }
                          setState(() {});
                        },
                      ),
                      selectedTab == 0
                          ? shimmerIsLoading
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => ShimmerCard(),
                                    childCount: 2,
                                  ),
                                )
                              : shipmentsIsEmpty
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                date: shipments[index]
                                                    .expectedDate!,
                                                userName: shipments[index]
                                                    .user!
                                                    .name!,
                                                shipImage: shipments[index]
                                                            .items![0]
                                                            .photo ==
                                                        null
                                                    ? null
                                                    : base64ToImage(
                                                        shipments[index]
                                                            .items![0]
                                                            .photo!),
                                                userImage: shipments[index]
                                                            .user!
                                                            .profilePhoto ==
                                                        null
                                                    ? null
                                                    : base64ToUserImage(
                                                        shipments[index]
                                                            .user!
                                                            .profilePhoto!),
                                                bonus: shipments[index]
                                                    .reward
                                                    .toString(),
                                              )
                                            : Container(),
                                        childCount: shipments.length,
                                      ),
                                    )
                          : shimmerIsLoading
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => ShimmerCard(),
                                    childCount: 2,
                                  ),
                                )
                              : tripsIsEmpty
                                  ? SliverToBoxAdapter(
                                      child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              'images/no_trips.png',
                                              width: 350,
                                              height: 330,
                                            ),
                                          ),
                                          Container(
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "There are not any trips\n right now!",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => selectedTab == 1
                                            ? TripCard(
                                                origin: trips[index].origin,
                                                destination:
                                                    trips[index].destination,
                                                username:
                                                    trips[index].user?.name,
                                                availableWeight:
                                                    trips[index].available,
                                                consumedWeight:
                                                    trips[index].consumed,
                                                date: DateFormat('dd MMMM yyyy')
                                                    .format(trips[index]
                                                        .departDate!),
                                                userImage: trips[index]
                                                            .user
                                                            ?.profilePhoto ==
                                                        null
                                                    ? null
                                                    : base64ToImage(trips[index]
                                                        .user!
                                                        .profilePhoto!))
                                            : Container(),
                                        childCount: trips.length,
                                      ),
                                    )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    if (selectedTab == 0) {
                      await viewModel.create(token);
                      // cacheShipments(shipments);
                    } else {
                      await viewModel.getAlltrips(token);
                      // cacheTrips(trips);
                      // getChachedtrips().then((cachedTrips) {
                      //   if (cachedTrips.isNotEmpty) {
                      //     print('trips exist');
                      //     setState(() {
                      //       trips = cachedTrips;
                      //     });
                      //   } else {
                      //     viewModel.getAlltrips(token);
                      //   }
                      // });
                    }
                    setState(() {});
                  },
                  child: Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: CustomScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          expandedHeight:
                              MediaQuery.of(context).size.height * .244,
                          floating: false,
                          pinned: true,
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          title: Text(
                            'Hatly',
                            style: GoogleFonts.poppins(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          actions: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      // margin: EdgeInsets.only(right: 20),
                                      ),
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.13),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(top: 30),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                          unselectedLabelStyle:
                                              GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                          labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                          labelColor: Colors.black,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          indicator: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          onTap: (index) async {
                                            selectedTab = index;
                                            print('index $index');
                                            if (selectedTab == 1) {
                                              getTrips();
                                            } else {
                                              getShipments();
                                            }
                                          },
                                          tabs: const [
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
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.04),
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
                        selectedTab == 0
                            ? shimmerIsLoading
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => ShimmerCard(),
                                      childCount: 2,
                                    ),
                                  )
                                : shipmentsIsEmpty
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  title:
                                                      shipments[index].title!,
                                                  from: shipments[index].from!,
                                                  to: shipments[index].to!,
                                                  date: shipments[index]
                                                      .expectedDate!,
                                                  userName: shipments[index]
                                                      .user!
                                                      .name!,
                                                  shipImage: shipments[index]
                                                              .items![0]
                                                              .photo ==
                                                          null
                                                      ? null
                                                      : base64ToImage(
                                                          shipments[index]
                                                              .items![0]
                                                              .photo!),
                                                  userImage: shipments[index]
                                                              .user!
                                                              .profilePhoto ==
                                                          null
                                                      ? null
                                                      : base64ToUserImage(
                                                          shipments[index]
                                                              .user!
                                                              .profilePhoto!),
                                                  bonus: shipments[index]
                                                      .reward
                                                      .toString(),
                                                )
                                              : Container(),
                                          childCount: shipments.length,
                                        ),
                                      )
                            : shimmerIsLoading
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => ShimmerCard(),
                                      childCount: 2,
                                    ),
                                  )
                                : tripsIsEmpty
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'images/no_trips.png',
                                                width: 350,
                                                height: 330,
                                              ),
                                            ),
                                            Container(
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "There are not any trips\n right now!",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    : SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) => selectedTab == 1
                                              ? TripCard(
                                                  origin: trips[index].origin,
                                                  destination:
                                                      trips[index].destination,
                                                  username:
                                                      trips[index].user?.name,
                                                  availableWeight:
                                                      trips[index].available,
                                                  consumedWeight:
                                                      trips[index].consumed,
                                                  date:
                                                      DateFormat('dd MMMM yyyy')
                                                          .format(trips[index]
                                                              .departDate!),
                                                  userImage: trips[index]
                                                              .user
                                                              ?.profilePhoto ==
                                                          null
                                                      ? null
                                                      : base64ToImage(
                                                          trips[index]
                                                              .user!
                                                              .profilePhoto!))
                                              : Container(),
                                          childCount: trips.length,
                                        ),
                                      )
                      ],
                    ),
                  ),
                );
        });
  }

  void getTrips() {
    getChachedtrips().then((cachedTrips) {
      if (cachedTrips.isNotEmpty) {
        print('trips exist');
        setState(() {
          trips = cachedTrips;
        });
      } else {
        setState(() {
          viewModel.getAlltrips(token);
        });
      }
    });
  }

  void getShipments() {
    getCachedShipments().then((cachedShipments) {
      if (cachedShipments.isNotEmpty) {
        print('exist');
        setState(() {
          shipments = cachedShipments;
          shimmerIsLoading = false;
        });
      } else {
        viewModel.create(token); // Fetch from API if cache is empty
      }
    });
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
