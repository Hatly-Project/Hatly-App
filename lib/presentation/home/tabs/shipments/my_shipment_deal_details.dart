import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_argument.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_arguments.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';

class MyShipmentDealDetails extends StatefulWidget {
  static const routeName = 'MyShipmentDealDetails';
  const MyShipmentDealDetails({super.key});

  @override
  State<MyShipmentDealDetails> createState() => _MyShipmentDealDetailsState();
}

class _MyShipmentDealDetailsState extends State<MyShipmentDealDetails> {
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  late LoggedInState loggedInState;
  late String token;
  late String dealId;

  GetMyShipmentDealDetailsViewModel viewModel =
      GetMyShipmentDealDetailsViewModel();

  Future<void> getMyShipmentDealDetails(
      {required String dealId, required String token}) async {
    return viewModel.getMyShipmentDealDetails(dealId: dealId, token: token);
  }

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
    // viewModel.getMyShipmentDealDetails(dealId: dealId, token: token);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments
        as MyShipmentDealDetailsArgument;
    var dealDto = args.dealDto;
    var shipmentDto = args.shipmentDto;
    dealId = dealDto.id.toString();

    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is GetMyShipmentDealDetailsLoadingState) {
            isLoading = true;
          } else if (state is GetMyShipmentDealDetailsFailState) {
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
          if (previous is GetMyShipmentDealDetailsLoadingState) {
            isLoading = false;
          }
          if (current is GetMyShipmentDealDetailsLoadingState ||
              current is GetMyShipmentDealDetailsFailState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetMyShipmentDealDetailsSuccessState) {
            var deal = state.responseDto.deal;
          }
          return Stack(
            children: [
              Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    centerTitle: true,
                    iconTheme: IconThemeData(color: Colors.white),

                    title: Text(
                      'Deal Details',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    // actions: [
                    //   IconButton(
                    //     onPressed: () => showShipmentBottomSheet(context, countries),
                    //     icon: const Icon(
                    //       Icons.add,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ],
                  ),
                  body: Platform.isIOS
                      ? CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          slivers: [
                            CupertinoSliverRefreshControl(
                              onRefresh: () async {
                                await viewModel.getMyShipmentDealDetails(
                                    dealId: dealId, token: token);
                                setState(() {});
                              },
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  MyShipmentCard(
                                    title: shipmentDto.title!,
                                    from: shipmentDto.from!,
                                    to: shipmentDto.to!,
                                    date: DateFormat('dd MMMM yyyy')
                                        .format(shipmentDto.expectedDate!),
                                    shipmentDto: shipmentDto,
                                    shipImage: Image.network(
                                      shipmentDto
                                          .items!.first.photos!.first.photo!,
                                      fit: BoxFit.fitHeight,
                                      width: 100,
                                      height: 100,
                                    ), //
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Color.fromRGBO(
                                                  47, 40, 77, 30)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: dealDto
                                                                      .traveler!
                                                                      .profilePhoto !=
                                                                  null
                                                              ? Image.network(
                                                                  dealDto
                                                                      .traveler!
                                                                      .profilePhoto,
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              dealDto.traveler!
                                                                  .firstName!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              '${dealDto.traveler!.averageRating.toString()} Reviews',
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              '${substractDates(dealDto.trip!.createdAt!)} days ago',
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Card(
                                                      color: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.amber,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        .17,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        'Departure',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        .2,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        '${DateFormat('dd-MMM-yyyy').format(dealDto.trip!.departDate!)}',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .29,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      dealDto
                                                                          .trip!
                                                                          .origin!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Image.asset(
                                                                  'images/black-plane-2.png',
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .29,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      dealDto
                                                                          .trip!
                                                                          .destination!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .3,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Available Weight',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .1,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      '${dealDto.trip?.available} Kg',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .33,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Consumed Weight',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .1,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      '${dealDto.trip?.consumed} Kg',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                          color: Color.fromARGB(
                                                              255,
                                                              140,
                                                              128,
                                                              153),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .13,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child: Text(
                                                                    'Notes:  ',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .5,
                                                                child: Text(
                                                                  dealDto.trip
                                                                          ?.note ??
                                                                      'No Notes',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                          color: Color.fromARGB(
                                                              255,
                                                              140,
                                                              128,
                                                              153),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .3,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child: Text(
                                                                    'Meeting Points:  ',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .35,
                                                                child: Text(
                                                                  dealDto.trip
                                                                          ?.addressMeeting ??
                                                                      'Any',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Container(
                                              //   width: double.infinity,
                                              //   decoration: BoxDecoration(
                                              //       color: Colors.amber,
                                              //       borderRadius: BorderRadius.only(
                                              //           bottomLeft: Radius.circular(12),
                                              //           bottomRight: Radius.circular(12))),
                                              //   child: ElevatedButton(
                                              //     style: ElevatedButton.styleFrom(
                                              //         minimumSize: Size(double.infinity, 50),
                                              //         elevation: 0,
                                              //         shape: RoundedRectangleBorder(
                                              //             borderRadius: BorderRadius.only(
                                              //                 bottomLeft: Radius.circular(12),
                                              //                 bottomRight: Radius.circular(12))),
                                              //         backgroundColor: Colors.amber,
                                              //         padding:
                                              //             const EdgeInsets.symmetric(vertical: 12)),
                                              //     onPressed: () {
                                              //       _showShipmentsListBottomSheet(
                                              //           context, trip, showSuccessDialog);
                                              //     },
                                              //     child: Text(
                                              //       'Send Offer',
                                              //       style: TextStyle(
                                              //           fontSize: 15,
                                              //           color: Theme.of(context).primaryColor,
                                              //           fontWeight: FontWeight.bold),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color:
                                              Color.fromRGBO(47, 40, 77, 30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Traveler Reward :',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  '${dealDto.counterReward} \$',
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Hatly Fees :',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    '${dealDto.hatlyFees} \$',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Payment Fees :',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    '${dealDto.paymentFees} \$',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              fillOverscroll: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                  MediaQuery.sizeOf(context).width *
                                                      .3,
                                                  MediaQuery.sizeOf(context)
                                                          .height *
                                                      .07),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 51, 114, 53),
                                                  width: 1),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 51, 114, 53),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () {
                                            // _showTripsListBottomSheet(context,
                                            //     showSuccessDialog, shipmentDto);
                                            // login();
                                          },
                                          child: const Text(
                                            'Accept',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      .3,
                                                  MediaQuery.sizeOf(context)
                                                          .height *
                                                      .07),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              side: const BorderSide(
                                                  color: Colors.amber,
                                                  width: 1),
                                              backgroundColor: Colors.amber,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () {
                                            // _showTripsListBottomSheet(context,
                                            //     showSuccessDialog, shipmentDto);
                                            // login();
                                          },
                                          child: const FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              'Counter Offer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      .3,
                                                  MediaQuery.sizeOf(context)
                                                          .height *
                                                      .07),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              side: BorderSide(
                                                  color: Colors.red, width: 1),
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () {
                                            // _showTripsListBottomSheet(context,
                                            //     showSuccessDialog, shipmentDto);
                                            // login();
                                          },
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await viewModel.getMyShipmentDealDetails(
                                dealId: dealId, token: token);
                            setState(() {});
                          },
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            slivers: [
                              CupertinoSliverRefreshControl(
                                onRefresh: () async {},
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    MyShipmentCard(
                                      title: shipmentDto.title!,
                                      from: shipmentDto.from!,
                                      to: shipmentDto.to!,
                                      date: DateFormat('dd MMMM yyyy')
                                          .format(shipmentDto.expectedDate!),
                                      shipmentDto: shipmentDto,
                                      shipImage: Image.network(
                                        shipmentDto
                                            .items!.first.photos!.first.photo!,
                                        fit: BoxFit.fitHeight,
                                        width: 100,
                                        height: 100,
                                      ), //
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Color.fromRGBO(
                                                    47, 40, 77, 30)),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: dealDto
                                                                        .traveler!
                                                                        .profilePhoto !=
                                                                    null
                                                                ? Image.network(
                                                                    dealDto
                                                                        .traveler!
                                                                        .profilePhoto,
                                                                    width: 50,
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Container(
                                                                    height: 50,
                                                                    width: 50,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                dealDto
                                                                    .traveler!
                                                                    .firstName!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                '${dealDto.traveler!.averageRating.toString()} Reviews',
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                '${substractDates(dealDto.trip!.createdAt!)} days ago',
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Card(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 35,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .amber,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            12),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            12)),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          .17,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          'Departure',
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Theme.of(context).primaryColor),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          MediaQuery.sizeOf(context).width *
                                                                              .2,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          '${DateFormat('dd-MMM-yyyy').format(dealDto.trip!.departDate!)}',
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Theme.of(context).primaryColor),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .29,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        dealDto
                                                                            .trip!
                                                                            .origin!,
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
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
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        dealDto
                                                                            .trip!
                                                                            .destination!,
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .3,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        'Available Weight',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .1,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        '${dealDto.trip?.available} Kg',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .33,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        'Consumed Weight',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .1,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        '${dealDto.trip?.consumed} Kg',
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  12),
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    140,
                                                                    128,
                                                                    153),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .13,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Notes:  ',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .5,
                                                                  child: Text(
                                                                    dealDto.trip
                                                                            ?.note ??
                                                                        'No Notes',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  12),
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    140,
                                                                    128,
                                                                    153),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .3,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Meeting Points:  ',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .35,
                                                                  child: Text(
                                                                    dealDto.trip
                                                                            ?.addressMeeting ??
                                                                        'Any',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //   width: double.infinity,
                                                //   decoration: BoxDecoration(
                                                //       color: Colors.amber,
                                                //       borderRadius: BorderRadius.only(
                                                //           bottomLeft: Radius.circular(12),
                                                //           bottomRight: Radius.circular(12))),
                                                //   child: ElevatedButton(
                                                //     style: ElevatedButton.styleFrom(
                                                //         minimumSize: Size(double.infinity, 50),
                                                //         elevation: 0,
                                                //         shape: RoundedRectangleBorder(
                                                //             borderRadius: BorderRadius.only(
                                                //                 bottomLeft: Radius.circular(12),
                                                //                 bottomRight: Radius.circular(12))),
                                                //         backgroundColor: Colors.amber,
                                                //         padding:
                                                //             const EdgeInsets.symmetric(vertical: 12)),
                                                //     onPressed: () {
                                                //       _showShipmentsListBottomSheet(
                                                //           context, trip, showSuccessDialog);
                                                //     },
                                                //     child: Text(
                                                //       'Send Offer',
                                                //       style: TextStyle(
                                                //           fontSize: 15,
                                                //           color: Theme.of(context).primaryColor,
                                                //           fontWeight: FontWeight.bold),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Color.fromRGBO(47, 40, 77, 30)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Traveler Reward :',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    '${dealDto.counterReward} \$',
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Hatly Fees :',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    Text(
                                                      '${dealDto.hatlyFees} \$',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Payment Fees :',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    Text(
                                                      '${dealDto.paymentFees} \$',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                fillOverscroll: true,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                    MediaQuery.sizeOf(context).width *
                                                        .3,
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        .07),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 51, 114, 53),
                                                    width: 1),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 51, 114, 53),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 12)),
                                            onPressed: () {
                                              // _showTripsListBottomSheet(context,
                                              //     showSuccessDialog, shipmentDto);
                                              // login();
                                            },
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        .3,
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        .07),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: BorderSide(
                                                    color: Colors.amber,
                                                    width: 1),
                                                backgroundColor: Colors.amber,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12)),
                                            onPressed: () {
                                              // _showTripsListBottomSheet(context,
                                              //     showSuccessDialog, shipmentDto);
                                              // login();
                                            },
                                            child: const FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                'Counter Offer',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        .3,
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        .07),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: BorderSide(
                                                    color: Colors.red,
                                                    width: 1),
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12)),
                                            onPressed: () {
                                              // _showTripsListBottomSheet(context,
                                              //     showSuccessDialog, shipmentDto);
                                              // login();
                                            },
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
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
        });
  }

  String substractDates(DateTime dateTime) {
    DateTime dateNow = DateTime.now();

    var substractedDate = dateNow.difference(dateTime);

    var daysAgo = substractedDate.inDays;

    return daysAgo.toString();
  }
}
