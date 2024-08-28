import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/shipment_card_matching_shipments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_details_screen_viewmodel.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MatchingShipmentsScreen extends StatefulWidget {
  TripsDto tripsDto;
  MatchingShipmentsScreen({required this.tripsDto});

  @override
  State<MatchingShipmentsScreen> createState() =>
      _MatchingShipmentsScreenState();
}

class _MatchingShipmentsScreenState extends State<MatchingShipmentsScreen> {
  ScrollController scrollController = ScrollController();
  late LoggedInState loggedInState;
  late MyTripDetailsScreenViewModel viewModel;

  List<ShipmentDto> matchingShipments = [];
  bool isMatchingShipmentsEmpty = false;
  late String token;
  late int tripId;
  // late MyShipmentDealDetailsArgument args;
  bool isLoading = true;
  late AccessTokenProvider accessTokenProvider;
  Future<void> getMyTripMatchingShipments(
      {required String token, required int tripId}) async {
    await viewModel.getMyTripMatchingShipments(token: token, tripId: tripId);
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
    print('dealll ${widget.tripsDto.destination}');
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      if (accessTokenProvider.accessToken != null) {
        viewModel.getMyTripMatchingShipments(
            token: accessTokenProvider.accessToken!,
            tripId: widget.tripsDto.id!.length
            );
      }

      // token = loggedInState.accessToken;
      // // Now you can use the 'token' variable as needed in your code.
      // print('User token: $token');
      // print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the   scenario where the user is not logged in.
    }

    // getCachedMyShipmentsDeals().then((cachedDeals) async {
    //   if (cachedDeals.isNotEmpty) {
    //     setState(() {
    //       matchingShipments = cachedDeals;
    //     });
    //   } else {
    //     await viewModel.getMyTripMatchingShipments(
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
    // args = ModalRoute.of(context)?.settings.arguments
    //     as MyShipmentDealDetailsArgument;
    tripId = widget.tripsDto.id!.length;
    // getMyTripMatchingShipments(token: token, shipmentId: shipment.id!);

    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is GetTripMatchingShipmentsLoadingState) {
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
        } else if (state is GetTripMatchingShipmentsFailState) {
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
        if (previous is GetTripMatchingShipmentsLoadingState) {
          // DialogUtils.hideDialog(context);
          isLoading = false;
        }
        if (current is GetTripMatchingShipmentsLoadingState ||
            current is GetTripMatchingShipmentsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetTripMatchingShipmentsSuccessState) {
          // print('gettrips success');
          matchingShipments = state.responseDto.shipments ?? [];
          // print('reward ${matchingShipments.first.traveler!.averageRating}');
          if (matchingShipments.isEmpty) {
            print('matchingShipments empty');
            isMatchingShipmentsEmpty = true;
            // clearCached();
          } else {
            isMatchingShipmentsEmpty = false;
            // cacheMyShipmentsDeals(matchingShipments);
            print('matchingShipments not empty');
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
                              await viewModel.getMyTripMatchingShipments(
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
                        isMatchingShipmentsEmpty
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
                                            Image.asset('images/no_trips.png'),
                                      ),
                                      Text(
                                        "There is no matching shipments for this trip",
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
                                    (context, index) => MatchingShipmentCard(
                                        shipmentDto: matchingShipments[index],
                                        deal: Deal(
                                          shipmentDto: matchingShipments[index],
                                          tripsDto: widget.tripsDto,
                                        )),
                                    childCount: matchingShipments.length),
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
                        await viewModel.getMyTripMatchingShipments(
                            token: accessTokenProvider.accessToken!,
                            tripId: widget.tripsDto.id!.length);
                      }
                      // cacheMyShipmentsDeals(matchingShipments);
                      setState(() {});
                    },
                    child: Scaffold(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: isMatchingShipmentsEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.sizeOf(context).width *
                                            .25),
                                    child: Image.asset('images/no_trips.png'),
                                  ),
                                  Text(
                                    "There is no matching shipments for this trip",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) =>
                                  MatchingShipmentCard(
                                      shipmentDto: matchingShipments[index],
                                      deal: Deal(
                                        shipmentDto: matchingShipments[index],
                                        tripsDto: widget.tripsDto,
                                      )),
                              itemCount: matchingShipments.length,
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
