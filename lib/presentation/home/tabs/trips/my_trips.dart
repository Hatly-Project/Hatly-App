import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/my_trip_card.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/components/trip_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipments_screen_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_bottom_sheet.dart';
import 'package:hatly/presentation/components/countries_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/create_trip_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/create_trip_screen.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_viewmodel.dart';
import 'package:hatly/presentation/login/login_screen.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/item_dto.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';

class MyTripsTab extends StatefulWidget {
  static const String routeName = 'MyTrips';

  MyTripsTab({super.key});

  @override
  State<MyTripsTab> createState() => _MyTripsTabState();
}

class _MyTripsTabState extends State<MyTripsTab> {
  late MyTripsViewmodel viewModel;
  late AccessTokenProvider accessTokenProvider;
  List<TripsDto> myTrips = [];
  late String token;
  late CountriesDto countriesDto;
  ScrollController scrollController = ScrollController();
  bool isMyTripsEmpty = false;
  Image? shipImage;
  late LoggedInState loggedInState;

  @override
  void initState() {
    super.initState();

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = MyTripsViewmodel(accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      // token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      // print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }

    //Check for cached shipments when initializing
    getCachedMyTrips().then((cachedTrips) {
      if (cachedTrips.isNotEmpty) {
        print('exist');
        setState(() {
          myTrips = cachedTrips;
        });
      } else {
        if (accessTokenProvider.accessToken != null) {
          // token = accessTokenProvider.accessToken!;
          viewModel.getMyTrip(token: accessTokenProvider.accessToken!);
          print('no Exist'); // Fetch from API if cache is empty
        }
      }
    });
  }

  // a method for caching the shipments list
  Future<void> cacheMytrips(List<TripsDto> trips) async {
    final box = await Hive.openBox(
        'trips${loggedInState.user.email!.replaceAll('@', '_at_')}');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final tripsMaps = trips.map((trip) => trip.toJson()).toList();

    // Clear existing data and store the new data in the box
    print('done caching');
    await box.clear();
    await box.addAll(tripsMaps);
  }

  Future<List<TripsDto>> getCachedMyTrips() async {
    final box = await Hive.openBox(
        'trips${loggedInState.user.email!.replaceAll('@', '_at_')}');
    final tripsMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final trips = tripsMaps.map((trip) => TripsDto.fromJson(trip)).toList();

    return trips;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    print(args.countriesFlagsDto);
    countriesDto = args.countriesFlagsDto;
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is GetMyTripsLoadingState) {
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
        } else if (state is GetMyTripsFailState) {
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
        if (previous is GetMyTripsLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is GetMyTripsLoadingState ||
            current is GetMyTripsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetMyTripsSuccessState) {
          print('getSuccess');
          List<TripsDto>? trips = state.responseDto.trips ?? [];
          if (trips.isEmpty) {
            isMyTripsEmpty = true;
            clearData();
          } else {
            myTrips = trips;
            isMyTripsEmpty = false;
            cacheMytrips(myTrips);
          }
        }
        return Platform.isIOS
            ? Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'My Trips',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTripScreen()));
                        Navigator.pushNamed(context, CreateTripScreen.routeName,
                            arguments: CreatetripScreenArguments(
                                countriesFlagsDto: countriesDto));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                body: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () async {
                        if (accessTokenProvider.accessToken != null) {
                          // token = accessTokenProvider.accessToken!;
                          viewModel.getMyTrip(
                              token: accessTokenProvider.accessToken!);
                          cacheMytrips(myTrips);

                          print('no Exist'); // Fetch from API if cache is empty
                        }
                        setState(() {});
                      },
                    ),
                    isMyTripsEmpty
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('images/no_user_trip.png'),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "You don't have any trips,\npress the add button to add a trip",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => MyTripCard(
                                origin: myTrips[index].origin,
                                destination: myTrips[index].destination,
                                availableWeight: myTrips[index].available,
                                date: DateFormat('dd MMMM yyyy')
                                    .format(myTrips[index].departDate!),
                                consumedWeight: myTrips[index].consumed ?? 0,
                              ),
                              childCount: myTrips.length,
                            ),
                          )
                  ],
                ))
            : RefreshIndicator(
                onRefresh: () async {
                  if (accessTokenProvider.accessToken != null) {
                    // token = accessTokenProvider.accessToken!;
                    viewModel.getMyTrip(
                        token: accessTokenProvider.accessToken!);
                    cacheMytrips(myTrips);

                    print('no Exist'); // Fetch from API if cache is empty
                  }
                  setState(() {});
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      'My Trips',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, CreateTripScreen.routeName,
                              arguments: CreatetripScreenArguments(
                                  countriesFlagsDto: countriesDto));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  body: isMyTripsEmpty
                      ? SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('images/no_user_trip.png'),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "You don't have any trips,\npress the add button to add a trip",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: myTrips.length,
                          itemBuilder: (context, index) => MyTripCard(
                            origin: myTrips[index].origin,
                            destination: myTrips[index].destination,
                            availableWeight: myTrips[index].available,
                            date: DateFormat('dd MMMM yyyy')
                                .format(myTrips[index].departDate!),
                            consumedWeight: myTrips[index].consumed ?? 0,
                          ),
                        ),
                ),
              );
      },
    );
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

  void clearData() async {
    final box = await Hive.openBox(
        'trips${loggedInState.user.email!.replaceAll('@', '_at_')}');

    await box.clear();
    await box.close();
  }

  void onError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        animation: AlwaysStoppedAnimation(BorderSide.strokeAlignInside),
        dismissDirection: DismissDirection.down,
        content: Container(
          padding: EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oh! Fail',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                errorMessage,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void done(
  //     String fromCountry,
  //     String fromState,
  //     String toState,
  //     String toCountry,
  //     String date,
  //     String name,
  //     String note,
  //     String bonus,
  //     List<ItemDto> items) {
  //   viewModel.create(
  //       token: token,
  //       from: fromCountry,
  //       to: toCountry,
  //       date: date,
  //       title: name,
  //       note: note,
  //       reward: double.tryParse(bonus),
  //       items: items);
  //   print(
  //       '$name , $note , $fromCountry , $fromState , $toCountry , $toState , $bonus , $date itemWeighttt ${items.first.weight}');
  //   setState(() {});
  //   Navigator.of(context).pop();
  // }

  // void showShipmentBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => AddShipmentBottomSheet(
  //       onError: onError,
  //       done: done,
  //     ),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //   );
  // }
}
