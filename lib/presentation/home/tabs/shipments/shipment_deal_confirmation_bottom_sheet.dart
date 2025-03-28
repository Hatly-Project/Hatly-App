import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_viewmodel.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/components/my_shipments_card_deals.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_viewmodel.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShipmentDealConfirmationBottomSheet extends StatefulWidget {
  Deal deal;
  Function showSuccessDialog;
  ShipmentDealConfirmationBottomSheet(
      {required this.deal, required this.showSuccessDialog});

  @override
  State<ShipmentDealConfirmationBottomSheet> createState() =>
      _ShipmentDealConfirmationBottomSheetState();
}

class _ShipmentDealConfirmationBottomSheetState
    extends State<ShipmentDealConfirmationBottomSheet> {
  late ShipmentDealViewmodel viewModel;
  late AccessTokenProvider accessTokenProvider;
  bool isLoading = false;
  late LoggedInState loggedInState;
  late String token;

  @override
  void initState() {
    super.initState();
    print('created at from sheet ${widget.deal.shipmentDto.createdAt}');
    // print('trip name : ${widget.deal.tripsDto.user?.name}');
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = ShipmentDealViewmodel(accessTokenProvider);
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is ShipmentDealLoadingState) {
          isLoading = true;
        } else if (state is ShipmentDealFailState) {
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
        if (previous is ShipmentDealLoadingState) {
          isLoading = false;
        }
        if (current is ShipmentDealLoadingState ||
            current is ShipmentDealFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        Deal deal = widget.deal;
        List<TripsDto> trips = [];
        trips.add(deal.tripsDto);
        if (state is ShipmentDealSuccessState) {
          print('Deal Success');
          var successMsg = state.responseDto.message;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();

            widget.showSuccessDialog(successMsg);
          });

          // if (Platform.isIOS) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   DialogUtils.showDialogIos(
          //       alertMsg: 'Success',
          //       alertContent: successMsg,
          //       context: context);
          // });
          // } else {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     DialogUtils.showDialogAndroid(
          //         alertMsg: 'Success',
          //         alertContent: successMsg,
          //         context: context);
          //   });
          // }
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  'Confirm Deal',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(47, 40, 77, 30)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child:
                                          deal.shipmentDto.user!.profilePhoto !=
                                                  null
                                              ? Image.network(
                                                  deal.shipmentDto.user!
                                                      .profilePhoto!,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.grey[300],
                                                ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          deal.shipmentDto.user!.firstName!,
                                          overflow: TextOverflow.fade,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${deal.shipmentDto.user!.averageRating.toString()} Reviews',
                                          overflow: TextOverflow.fade,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        // Text(
                                        //   '${substractDates(deal.shipmentDto.createdAt ??)} days ago',
                                        //   overflow: TextOverflow.fade,
                                        //   style: GoogleFonts.poppins(
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.white),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MyShipmentCardForDeals(
                                  title: deal.shipmentDto.title!,
                                  from: deal.shipmentDto.from!,
                                  to: deal.shipmentDto.to!,
                                  date: DateFormat('dd MMMM yyyy')
                                      .format(deal.shipmentDto.expectedDate!),
                                  shipImage: Image.network(
                                    deal.shipmentDto.items!.first.photos!.first
                                        .photo!,
                                    fit: BoxFit.fitWidth,
                                    width: 100,
                                    height: 100,
                                  ), //
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Color.fromARGB(255, 140, 128, 153),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .13,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Notes:  ',
                                                overflow: TextOverflow.fade,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: Text(
                                              deal.shipmentDto.notes ??
                                                  'No Notes',
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.visible,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Color.fromARGB(255, 140, 128, 153),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .3,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Meeting Points:  ',
                                                overflow: TextOverflow.fade,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                            child: Text(
                                              deal.tripsDto.addressMeeting ??
                                                  'Any',
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        .17,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Departure',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        .2,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${DateFormat('dd-MMM-yyyy').format(deal.tripsDto.departDate!)}',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .29,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  deal.tripsDto.origin!,
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              'images/black-plane-2.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .29,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  deal.tripsDto.destination!,
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Available Weight',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .1,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '${deal.tripsDto.available} Kg',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .33,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Consumed Weight',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .1,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '${deal.tripsDto.consumed} Kg',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12))),
                                  backgroundColor: Colors.amber,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () {
                                if (accessTokenProvider.accessToken != null) {
                                  // token = accessTokenProvider.accessToken!;
                                  viewModel.sendDealOnTrip(
                                      token: accessTokenProvider.accessToken!,
                                      tripId: deal.tripsDto.id!,
                                      reward: deal.shipmentDto.reward,
                                      shipmentId: deal.shipmentDto.id);
                                }
                              },
                              child: Text(
                                'Confirm Offer',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Platform.isIOS
                          ? const CupertinoActivityIndicator(
                              radius: 25,
                              color: Colors.white,
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            )),
                ),
              )
          ],
        );
      },
    );
  }

  String substractDates(DateTime dateTime) {
    DateTime dateNow = DateTime.now();

    var substractedDate = dateNow.difference(dateTime);

    var daysAgo = substractedDate.inDays;

    return daysAgo.toString();
  }
}
