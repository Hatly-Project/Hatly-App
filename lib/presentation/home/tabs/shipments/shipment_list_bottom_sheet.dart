import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/my_shipments_card_deals.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/components/my_shipments_shimmer_card.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipments_screen_viewmodel.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShipmentsListBottomSheet extends StatefulWidget {
  TripsDto tripsDto;
  Function showSuccessDialog;
  ShipmentsListBottomSheet(
      {required this.tripsDto, required this.showSuccessDialog});

  @override
  State<ShipmentsListBottomSheet> createState() =>
      _ShipmentsListBottomSheetState();
}

class _ShipmentsListBottomSheetState extends State<ShipmentsListBottomSheet> {
  ScrollController scrollController = ScrollController();
  late MyShipmentsScreenViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  List<ShipmentDto> myShipments = [];
  late String token;
  Image? shipImage;
  bool isMyshipmentEmpty = false, shimmerIsLoading = true;
  late LoggedInState loggedInState;

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = MyShipmentsScreenViewModel(accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      // token = loggedInState.accessToken;
      // // Now you can use the 'token' variable as needed in your code.
      // print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
    if (accessTokenProvider.accessToken != null) {
      // token = accessTokenProvider.accessToken!;
      viewModel.getMyShipments(token: accessTokenProvider.accessToken!);
      // cacheMytrips(myTrips);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is GetMyShipmentsLoadingState) {
          shimmerIsLoading = true;
        } else if (state is GetMyShipmentsFailState) {
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
        if (previous is GetMyShipmentsLoadingState) {
          shimmerIsLoading = false;
        }
        if (current is GetMyShipmentsLoadingState ||
            current is GetMyShipmentsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetMyShipmentsSuccessState) {
          print('getMySuccess');
          myShipments = state.responseDto.shipments ?? [];
          if (myShipments.isEmpty) {
            isMyshipmentEmpty = true;
            print('empty');
          } else {
            isMyshipmentEmpty = false;
            print(
                'photoooo ${myShipments.first.items!.first.photos!.first.photo!}');
          }
          shimmerIsLoading = false;
        }
        return Container(
          height: 600,
          child: Platform.isIOS
              ? Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      "Select a shipment",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
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
                          if (accessTokenProvider.accessToken != null) {
                            // token = accessTokenProvider.accessToken!;
                            await viewModel.getMyShipments(
                                token: accessTokenProvider.accessToken!);
                            // cacheMytrips(myTrips);

                            print(
                                'no Exist'); // Fetch from API if cache is empty
                          }
                          setState(() {});
                        },
                      ),
                      shimmerIsLoading
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => MyShipmentShimmerCard(),
                                  childCount: 5),
                            )
                          : isMyshipmentEmpty
                              ? SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset('images/no_shipments.png'),
                                        Text(
                                          "You don't have any shipments, please add a shipment to send your offer",
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
                                      (context, index) => MyShipmentCard(
                                            title: myShipments[index].title!,
                                            from: myShipments[index].from!,
                                            to: myShipments[index].to!,
                                            date: DateFormat('dd MMMM yyyy')
                                                .format(myShipments[index]
                                                    .expectedDate!),
                                            isDealTap: true,
                                            showSuccessDialog:
                                                widget.showSuccessDialog,
                                            shipmentDto: myShipments[index],
                                            deal: Deal(
                                                shipmentDto: myShipments[index],
                                                tripsDto: widget.tripsDto),
                                            shipImage: Image.network(
                                              myShipments[index]
                                                  .items!
                                                  .first
                                                  .photos!
                                                  .first
                                                  .photo!,
                                              fit: BoxFit.fitHeight,
                                              width: 100,
                                              height: 100,
                                            ), //
                                          ),
                                      childCount: myShipments.length),
                                ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    if (accessTokenProvider.accessToken != null) {
                      // token = accessTokenProvider.accessToken!;
                      await viewModel.getMyShipments(
                          token: accessTokenProvider.accessToken!);
                      // cacheMytrips(myTrips);

                      print('no Exist'); // Fetch from API if cache is empty
                    }
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
                        "Select a shipment",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 17,
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
                        : isMyshipmentEmpty
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
                                itemBuilder: (context, index) => MyShipmentCard(
                                  title: myShipments[index].title!,
                                  from: myShipments[index].from!,
                                  to: myShipments[index].to!,
                                  shipmentDto: myShipments[index],
                                  showSuccessDialog: widget.showSuccessDialog,
                                  date: DateFormat('dd MMMM yyyy')
                                      .format(myShipments[index].expectedDate!),
                                  isDealTap: true,
                                  deal: Deal(
                                      shipmentDto: myShipments[index],
                                      tripsDto: widget.tripsDto),
                                  shipImage: Image.network(
                                    myShipments[index]
                                        .items!
                                        .first
                                        .photos!
                                        .first
                                        .photo!,
                                    fit: BoxFit.fitHeight,
                                    width: 100,
                                    height: 100,
                                  ), //
                                ),
                                itemCount: myShipments.length,
                              ),
                  ),
                ),
        );
      },
    );
  }
}
