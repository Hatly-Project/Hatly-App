import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/my_shipments_card_deals.dart';
import 'package:hatly/presentation/components/my_trip_card.dart';
import 'package:hatly/presentation/components/my_trip_card_for_deals.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_viewmodel.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/components/my_shipments_shimmer_card.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipments_screen_viewmodel.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';

class TripsListBottomSheet extends StatefulWidget {
  Function showSuccessDialog;
  ShipmentDto shipmentDto;
  TripsListBottomSheet(
      {required this.showSuccessDialog, required this.shipmentDto});

  @override
  State<TripsListBottomSheet> createState() => _ShipmentsListBottomSheetState();
}

class _ShipmentsListBottomSheetState extends State<TripsListBottomSheet> {
  ScrollController scrollController = ScrollController();
  MyTripsViewmodel viewModel = MyTripsViewmodel();
  List<TripsDto> myTrips = [];
  late String token;
  Image? shipImage;
  bool isMyTripsEmpty = false, shimmerIsLoading = true;
  late LoggedInState loggedInState;

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.token;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }

    viewModel.getMyTrip(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is GetMyTripsLoadingState) {
          shimmerIsLoading = true;
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
          shimmerIsLoading = false;
        }
        if (current is GetMyTripsLoadingState ||
            current is GetMyTripsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetMyTripsSuccessState) {
          print('getMySuccess');
          myTrips = state.responseDto.trips ?? [];
          if (myTrips.isEmpty) {
            isMyTripsEmpty = true;
            print('empty');
          } else {
            isMyTripsEmpty = false;
          }
          shimmerIsLoading = false;
        }
        return Container(
          // height: 500,
          child: Platform.isIOS
              ? Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      "Select a trip",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  body: CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                          viewModel.getMyTrip(token: token);
                          setState(() {});
                        },
                      ),
                      shimmerIsLoading
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => MyShipmentShimmerCard(),
                                  childCount: 5),
                            )
                          : isMyTripsEmpty
                              ? SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset('images/no_trips.png'),
                                        Text(
                                          "You don't have any trips, please add a trip to send your offer",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => MyTripCardForDeals(
                                            origin: myTrips[index].origin,
                                            destination:
                                                myTrips[index].destination,
                                            availableWeight:
                                                myTrips[index].available,
                                            showSuccessDialog:
                                                widget.showSuccessDialog,
                                            deal: Deal(
                                                shipmentDto: widget.shipmentDto,
                                                tripsDto: myTrips[index]),
                                            date: DateFormat('dd MMMM yyyy')
                                                .format(
                                                    myTrips[index].departDate!),
                                            consumedWeight:
                                                myTrips[index].consumed ?? 0,
                                          ),
                                      childCount: myTrips.length),
                                ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    viewModel.getMyTrip(token: token);
                    setState(() {});
                  },
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      elevation: 0,
                      title: Text(
                        "Select a trip",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    body: shimmerIsLoading
                        ? ListView.builder(
                            itemBuilder: (context, index) =>
                                MyShipmentShimmerCard(),
                            itemCount: 5,
                          )
                        : isMyTripsEmpty
                            ? SingleChildScrollView(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('images/no_shipments.png'),
                                      Text(
                                        "You don't have any shipments, please add a shipment to send your offer",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) =>
                                    MyTripCardForDeals(
                                  origin: myTrips[index].origin,
                                  destination: myTrips[index].destination,
                                  deal: Deal(
                                      shipmentDto: widget.shipmentDto,
                                      tripsDto: myTrips[index]),
                                  availableWeight: myTrips[index].available,
                                  showSuccessDialog: widget.showSuccessDialog,
                                  date: DateFormat('dd MMMM yyyy')
                                      .format(myTrips[index].departDate!),
                                  consumedWeight: myTrips[index].consumed ?? 0,
                                ),
                                itemCount: myTrips.length,
                              ),
                  ),
                ),
        );
      },
    );
  }
}
