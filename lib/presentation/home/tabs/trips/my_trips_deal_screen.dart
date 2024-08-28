import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/my_shipment_deal_card.dart';
import 'package:hatly/presentation/components/my_trip_deal_card.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_screen-viewmodel.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_details_screen_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_details_arguments.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MyTripDeals extends StatefulWidget {
  TripsDto tripsDto;
  MyTripDeals({required this.tripsDto});

  @override
  State<MyTripDeals> createState() => _TripDealsState();
}

class _TripDealsState extends State<MyTripDeals> {
  ScrollController scrollController = ScrollController();
  late LoggedInState loggedInState;
  late MyTripDetailsScreenViewModel viewModel;

  List<TripDealDto> deals = [];
  bool isMyTripsDealsEmpty = false;
  late String token;
  late int shipmentId;
  late MyTripsDetailsArguments args;
  bool isLoading = true;
  late AccessTokenProvider accessTokenProvider;
  Future<void> getMyTripDeals(
      {required String token, required int tripId}) async {
    await viewModel.getMyTripDeals(token: token, tripId: tripId);
  }

  @override
  void initState() {
    super.initState();

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);

    viewModel =
        MyTripDetailsScreenViewModel(accessTokenProvider: accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the   scenario where the user is not logged in.
    }

    if (accessTokenProvider.accessToken != null) {
      viewModel.getMyTripDeals(
          token: accessTokenProvider.accessToken!,
          tripId: widget.tripsDto.id!.length);
    }

    // getCachedMyShipmentsDeals().then((cachedDeals) async {
    //   if (cachedDeals.isNotEmpty) {
    //     setState(() {
    //       deals = cachedDeals;
    //     });
    //   } else {
    //     await viewModel.getMyshipmentDeals(
    //         token: token, shipmentId: shipmentId);
    //   }
    // });
  }

  // a method for caching the shipments list
  // Future<void> cacheMyShipmentsDeals(List<DealDto> shipmentsDeals) async {
  //   final box = await Hive.openBox(
  //       'shipmentsDeals_${loggedInState.user.email!.replaceAll('@', '_at_')}');

  //   // Convert List<ShipmentDto> to List<Map<String, dynamic>>
  //   final shipmentDealsMaps =
  //       shipmentsDeals.map((deal) => deal.toJson()).toList();

  //   // Clear existing data and store the new data in the box
  //   print('done caching');
  //   await box.clear();
  //   await box.addAll(shipmentDealsMaps);
  // }

  // Future<List<DealDto>> getCachedMyShipmentsDeals() async {
  //   final box = await Hive.openBox(
  //       'shipmentsDeals_${loggedInState.user.email!.replaceAll('@', '_at_')}');
  //   final shipmentDealsMaps = box.values.toList();

  //   // Convert List<Map<String, dynamic>> to List<ShipmentDto>
  //   final shipmentDeals = shipmentDealsMaps
  //       .map((shipmentMap) => DealDto.fromJson(shipmentMap))
  //       .toList();

  //   return shipmentDeals;
  // }

  Future<void> clearCached() async {
    final box = await Hive.openBox(
        'shipmentsDeals_${loggedInState.user.email!.replaceAll('@', '_at_')}');
    await box.clear();
  }

  @override
  Widget build(BuildContext context) {
    shipmentId = widget.tripsDto.id!.length;
    // getMyshipmentDeals(token: token, shipmentId: shipment.id!);

    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is MyTripDealsLoadingState) {
          print(state);
          isLoading = true;
          // if (Platform.isIOS) {
          //   DialogUtils.showDialogIos(
          //       context: context,
          //       alertMsg: 'Loading...',
          //       alertContent: state.loadingMessage);
          // } else {
          //   DialogUtils.showDialogAndroid(
          //       alertMsg: 'Loading',
          //       alertContent: state.loadingMessage,
          //       context: context);
          // }
        } else if (state is MyTripDealsFailState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                context: context,
                alertMsg: 'Fail',
                alertContent: state.failMessage);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Fail',
                alertContent: state.failMessage,
                context: context);
          }
        }
      },
      listenWhen: (previous, current) {
        if (previous is MyTripDealsLoadingState) {
          // DialogUtils.hideDialog(context);
          isLoading = false;
        }
        if (current is MyTripDealsLoadingState ||
            current is MyTripDealsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MyTripDealsSuccessState) {
          print('getDeals success');
          deals = state.responseDto.deals ?? [];
          // print('reward ${deals.first.traveler!.averageRating}');
          if (deals.isEmpty) {
            print('deal empty');
            isMyTripsDealsEmpty = true;
            // clearCached();
          } else {
            isMyTripsDealsEmpty = false;
            // cacheMyShipmentsDeals(deals);
            print('deal not empty');
          }
        }
        return Platform.isIOS
            ? Stack(
                children: [
                  Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: CustomScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            if (accessTokenProvider.accessToken != null) {
                              await viewModel.getMyTripDeals(
                                  token: accessTokenProvider.accessToken!,
                                  tripId: widget.tripsDto.id!.length);
                            }

                            setState(() {});
                          },
                        ),
                        // shimmerIsLoading
                        //     ?
                        // SliverList(
                        //     delegate: SliverChildBuilderDelegate(
                        //         (context, index) => MyShipmentShimmerCard(),
                        //         childCount: 5),
                        //   )
                        // : isMyshipmentEmpty
                        //     ?
                        isMyTripsDealsEmpty
                            ? SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.sizeOf(context)
                                                    .width *
                                                .25),
                                        child:
                                            Image.asset('images/no_deals.png'),
                                      ),
                                      Text(
                                        "You don't have any deals for this trip",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) => MyTripDealCard(
                                          tripsDto: widget.tripsDto,
                                          dealDto: deals[index],
                                        ),
                                    childCount: deals.length),
                              ),
                        // : SliverList(
                        //     delegate: SliverChildBuilderDelegate(
                        //         (context, index) => MyShipmentCard(
                        //               title: myShipments[index].title!,
                        //               from: myShipments[index].from!,
                        //               to: myShipments[index].to!,
                        //               date: DateFormat('dd MMMM yyyy')
                        //                   .format(myShipments[index]
                        //                       .expectedDate!),
                        //               shipImage: Image.network(
                        //                 myShipments[index]
                        //                     .items!
                        //                     .first
                        //                     .photos!
                        //                     .first
                        //                     .photo!,
                        //                 fit: BoxFit.fitHeight,
                        //                 width: 100,
                        //                 height: 100,
                        //               ), //
                        //             ),
                        //         childCount: myShipments.length),
                        //   ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  radius: 25,
                                  color: Colors.black,
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ),
                ],
              )
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      if (accessTokenProvider.accessToken != null) {
                        await viewModel.getMyTripDeals(
                            token: accessTokenProvider.accessToken!,
                            tripId: widget.tripsDto.id!.length);
                      }
                      // cacheMyShipmentsDeals(deals);
                      setState(() {});
                    },
                    child: Scaffold(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: isMyTripsDealsEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.sizeOf(context).width *
                                            .25),
                                    child: Image.asset('images/no_deals.png'),
                                  ),
                                  Text(
                                    "You don't have any deals for this trip",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) => MyTripDealCard(
                                tripsDto: widget.tripsDto,
                                dealDto: deals[index],
                              ),
                              itemCount: deals.length,
                            ),
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  radius: 25,
                                  color: Colors.black,
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ),
                ],
              );
      },
    );
  }
}
