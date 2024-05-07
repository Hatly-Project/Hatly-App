import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/shimmer_card.dart';
import 'package:hatly/presentation/components/trip_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/login/login_screen_arguments.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/firebase_messaging_provider.dart';
import 'package:hatly/services/local_notifications_service.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  FlutterSecureStorage storage = FlutterSecureStorage();
  // String token = '';
  int? totalShipmentsPage,
      currentShipmentsPage = 1,
      totalTripsPage,
      currentTripsPage = 1;
  HomeScreenArguments? args;
  late HomeScreenViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  bool shimmerIsLoading = true,
      isShipmentPaginationLoading = false,
      isTripPaginationLoading = false;

  @override
  void initState() {
    super.initState();
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = HomeScreenViewModel(accessTokenProvider);

//     UserProvider userProvider =
//         BlocProvider.of<UserProvider>(context, listen: false);

// // Check if the current state is LoggedInState and then access the token
//     if (userProvider.state is LoggedInState) {
//       LoggedInState loggedInState = userProvider.state as LoggedInState;
//       // token = loggedInState.accessToken;
//       // Now you can use the 'token' variable as needed in your code.
//       // getAccessToken(accessTokenProvider);
//     } else {
//       print(
//           'User is not logged in.'); // Handle the scenario where the user is not logged in.
//     }

    tabController = TabController(length: 2, vsync: this);
    if (selectedTab == 0) {
      getShipments();
    } else {
      getTrips();
    }
    tabController.addListener(() {
      setState(() {
        selectedTab = tabController.index;
      });
    });

    // Check for cached shipments when initializing
    // Future.delayed(Duration(milliseconds: 400), () {
    //   viewModel.create(token); // Fetch from API if cache is empty

    //   // getCachedShipments().then((cachedShipments) {
    //   //   if (cachedShipments.isNotEmpty) {
    //   //     print('exist');
    //   //     setState(() {
    //   //       shipments = cachedShipments;
    //   //       shimmerIsLoading = false;
    //   //     });
    //   //   } else {
    //   //     viewModel.create(token); // Fetch from API if cache is empty
    //   //   }
    //   // });
    // });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Future<String> getAccessToken(AccessTokenProvider accessTokenProvider) async {
  //   // String? accessToken = await storage.read(key: 'accessToken');

  //   if (accessTokenProvider.accessToken != null) {
  //     token = accessTokenProvider.accessToken!;
  //     // viewModel.create(accessTokenProvider.accessToken!);
  //     print('access $token');
  //   }

  //   setState(() {});
  //   return token;
  // }

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
    UserProvider userProvider = BlocProvider.of<UserProvider>(context);
    args = ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is GetAllShipsLoadingState) {
            print(state);
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
          } else if (state is GetAllShipsPaginationLoadingState) {
            isShipmentPaginationLoading = true;
          } else if (state is GetAllTripsPaginationLoadingState) {
            isTripPaginationLoading = true;
          } else if (state is GetAllShipsFailState) {
            print('status code ${state.statusCode}');
            if (Platform.isIOS) {
              DialogUtils.showDialogIos(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  statusCode: state.statusCode,
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'Login',
                        arguments:
                            LoginScreenArguments(args!.countriesFlagsDto));
                  },
                  context: context);
            } else {
              DialogUtils.showDialogAndroid(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'Login',
                        arguments:
                            LoginScreenArguments(args!.countriesFlagsDto));
                  },
                  statusCode: state.statusCode,
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
                  statusCode: state.statusCode,
                  context: context);
            } else {
              DialogUtils.showDialogAndroid(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  statusCode: state.statusCode,
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
          if (previous is GetAllShipsPaginationLoadingState) {
            isShipmentPaginationLoading = false;
          }
          if (previous is GetAllTripsPaginationLoadingState) {
            isTripPaginationLoading = false;
          }
          if (current is GetAllShipsLoadingState ||
              current is GetAllShipsFailState ||
              current is GetAllTripsLoadingState ||
              current is RefreshTokenFailState ||
              current is GetAllTripsFailState ||
              current is GetAllShipsPaginationLoadingState ||
              current is GetAllTripsPaginationLoadingState) {
            print(current);
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetAllShipsSuccessState) {
            print('shipment from build ${state.shipmentDto.length}');
            shipments = state.shipmentDto;
            currentShipmentsPage = state.currentPage;
            totalShipmentsPage = state.totalPages;
            print('ship length ${shipments.length}');
            if (shipments.isEmpty) {
              shipmentsIsEmpty = true;
              print("emptyyyy");
            } else {
              shipmentsIsEmpty = false;
              // cacheShipments(shipments);
              print('success ${shipments[0].items![0].photos!.first}');
            }
            shimmerIsLoading = false;
          }
          if (state is GetAllTripsSuccessState) {
            print('tripss');
            trips = state.tripsDto;
            currentTripsPage = state.currentPage;
            totalTripsPage = state.totalPages;
            if (trips.isEmpty) {
              tripsIsEmpty = true;
              print('trips empty');
            } else {
              print('tripss success');
              tripsIsEmpty = false;
              // cacheTrips(trips);
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
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    // margin: EdgeInsets.only(right: 20),
                                    ),
                                const Icon(
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
                                            setState(() {
                                              trips.clear();
                                            });
                                          } else {
                                            getShipments();
                                            setState(() {
                                              shipments.clear();
                                            });
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
                            if (accessTokenProvider.accessToken != null) {
                              await viewModel.create(
                                  accessTokenProvider.accessToken!,
                                  isRefresh: true);
                            }
                            setState(() {
                              shipments.clear();
                            });
                          } else {
                            final box = await Hive.openBox('trips');
                            await box.clear();
                            await box.close();
                            if (accessTokenProvider.accessToken != null) {
                              await viewModel.getAlltrips(
                                  accessTokenProvider.accessToken!,
                                  isRefresh: true);
                            }
                            setState(() {
                              trips.clear();
                            });
                          }
                        },
                      ),
                      selectedTab == 0
                          ? shimmerIsLoading
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => const ShimmerCard(),
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
                                  : buildShipmentsList(state)
                          : shimmerIsLoading
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => const ShimmerCard(),
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
                                  : !isTripPaginationLoading
                                      ? buildTripsList(
                                          state as GetAllTripsSuccessState)
                                      : buildTripsList(state
                                          as GetAllTripsPaginationLoadingState)
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    if (selectedTab == 0) {
                      if (accessTokenProvider.accessToken != null) {
                        await viewModel.create(accessTokenProvider.accessToken!,
                            isRefresh: true);
                      }
                      // cacheShipments(shipments);
                    } else {
                      if (accessTokenProvider.accessToken != null) {
                        await viewModel.getAlltrips(
                            accessTokenProvider.accessToken!,
                            isRefresh: true);
                      }
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
                              margin: const EdgeInsets.only(right: 10),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      // margin: EdgeInsets.only(right: 20),
                                      ),
                                  const Icon(
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
                                              setState(() {
                                                trips.clear();
                                              });
                                            } else {
                                              getShipments();
                                              print('tabeeed');
                                              setState(() {
                                                shipments.clear();
                                              });
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
                                      (context, index) => const ShimmerCard(),
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
                                    : !isShipmentPaginationLoading
                                        ? buildShipmentsList(state)
                                        : buildShipmentsList(state)
                            : shimmerIsLoading
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => const ShimmerCard(),
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
                                    : !isTripPaginationLoading
                                        ? buildTripsList(
                                            state as GetAllTripsSuccessState)
                                        : buildTripsList(state
                                            as GetAllTripsPaginationLoadingState)
                      ],
                    ),
                  ),
                );
        });
  }

  void getTrips() async {
    if (accessTokenProvider.accessToken != null) {
      await viewModel.getAlltrips(
        accessTokenProvider.accessToken!,
      );
    }

    // getChachedtrips().then((cachedTrips) {
    //   if (cachedTrips.isNotEmpty) {
    //     print('trips exist');
    //     setState(() {
    //       trips = cachedTrips;
    //     });
    //   } else {
    //     setState(() {
    //       viewModel.getAlltrips(token);
    //     });
    //   }
    // });
  }

  void showSuccessDialog(String successMsg) {
    _showShipmentDealConfirmedBottomSheet(context);
    // if (Platform.isIOS) {
    //   DialogUtils.showDialogIos(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // } else {
    //   DialogUtils.showDialogAndroid(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // }
  }

  Widget buildShipmentsList(Object? state) {
    AccessTokenProvider accessTokenProvider =
        Provider.of<AccessTokenProvider>(context);
    // String? accessToken = await storage.read(key: 'accessToken');

    return state is GetAllShipsSuccessState
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount:
                  state.hasReachedMax ? shipments.length : shipments.length + 1,
              (context, index) {
                if (index < shipments.length) {
                  return ShipmentCard(
                    shipmentDto: shipments[index],
                    showConfirmedBottomSheet: showSuccessDialog,
                  );
                } else {
                  if (totalShipmentsPage! >= currentShipmentsPage!) {
                    if (accessTokenProvider.accessToken != null) {
                      viewModel.create(accessTokenProvider.accessToken!,
                          isPagination: true);
                    }
                    // return Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Platform.isIOS
                    //         ? const CupertinoActivityIndicator(
                    //             radius: 11,
                    //             color: Colors.black,
                    //           )
                    //         : const CircularProgressIndicator(),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     Text(
                    //       "Loading",
                    //       textAlign: TextAlign.center,
                    //       style: GoogleFonts.poppins(
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.grey[400]),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //   ],
                    // );
                  }

                  // return Container();
                }
                return Container();
              },
            ),
          )
        : state is GetAllShipsPaginationLoadingState
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: shipments.length + 1,
                  (context, index) {
                    if (index < shipments.length) {
                      print('trueeeeee');
                      return ShipmentCard(
                        shipmentDto: shipments[index],
                        showConfirmedBottomSheet: showSuccessDialog,
                      );
                    } else {
                      print('1st else');
                      print(
                          'total $totalShipmentsPage current $currentShipmentsPage');
                      if (totalShipmentsPage! >= currentShipmentsPage!) {
                        print('elseeeee');

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Platform.isIOS
                                ? const CupertinoActivityIndicator(
                                    radius: 11,
                                    color: Colors.black,
                                  )
                                : const CircularProgressIndicator(),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Loading",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }

                      // return Container();
                    }
                  },
                ),
              )
            : SliverToBoxAdapter(child: Container());
  }

  Widget buildTripsList(Object? state) {
    return state is GetAllTripsSuccessState
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: state.hasReachedMax ? trips.length : trips.length + 1,
              (context, index) {
                if (index < trips.length) {
                  return TripCard(
                    tripsDto: trips[index],
                    // showConfirmedBottomSheet: showSuccessDialog,
                  );
                } else {
                  if (totalTripsPage! >= currentTripsPage!) {
                    if (accessTokenProvider.accessToken != null) {
                      viewModel.getAlltrips(accessTokenProvider.accessToken!,
                          isPagination: true);
                    }
                  }
                }
                return Container();
              },
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: trips.length + 1,
              (context, index) {
                if (index < trips.length) {
                  print('trueeeeee');
                  return TripCard(
                    tripsDto: trips[index],
                    // showConfirmedBottomSheet: showSuccessDialog,
                  );
                } else {
                  print('1st else');
                  print('total $totalTripsPage current $currentTripsPage');
                  if (totalTripsPage! >= currentTripsPage!) {
                    print('elseeeee');

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Platform.isIOS
                            ? const CupertinoActivityIndicator(
                                radius: 11,
                                color: Colors.black,
                              )
                            : const CircularProgressIndicator(),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Loading",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }

                  // return Container();
                }
                return Container();
              },
            ),
          );
  }

  void _showShipmentDealConfirmedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => const DealConfirmedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void getShipments() async {
    if (accessTokenProvider.accessToken != null) {
      await viewModel.create(
        accessTokenProvider.accessToken!,
      );
    }

    // getCachedShipments().then((cachedShipments) {
    //   if (cachedShipments.isNotEmpty) {
    //     print('exist');
    //     setState(() {
    //       shipments = cachedShipments;
    //       shimmerIsLoading = false;
    //     });
    //   } else {
    //     viewModel.create(token); // Fetch from API if cache is empty
    //   }
    // });
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
