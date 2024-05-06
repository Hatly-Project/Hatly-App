import 'dart:ffi' as size;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/card.dart' as card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/presentation/components/animated_alert_dialog.dart';
import 'package:hatly/presentation/components/confirm_cancel_deal_dialog.dart';
import 'package:hatly/presentation/components/counter_offer_dialog.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_argument.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_accepted_bottom_sheet.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/providers/payment_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyShipmentDealDetails extends StatefulWidget {
  static const routeName = 'MyShipmentDealDetails';
  MyShipmentDealDetailsArgument args;
  MyShipmentDealDetails({required this.args});

  @override
  State<MyShipmentDealDetails> createState() => _MyShipmentDealDetailsState();
}

class _MyShipmentDealDetailsState extends State<MyShipmentDealDetails> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late LoggedInState loggedInState;
  // late String token;
  late String dealId;
  bool isPaid = false;
  String? paymentIntentId, clientSecret;
  DealDto? dealResponseDto;
  late String? dealCreatorEmail;
  AcceptOrRejectShipmentDealResponseDto? acceptShipmentDealResponseDto;
  bool isAccepted = false, isRejected = false, isPaymentSheetOpened = false;

  late GetMyShipmentDealDetailsViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  late PaymentProvider paymentProvider;
  Future<void> getMyShipmentDealDetails(
      {required String dealId, required String token}) async {
    if (accessTokenProvider.accessToken != null) {
      return viewModel.getMyShipmentDealDetails(dealId: dealId, token: token);
    }
  }

  @override
  void initState() {
    super.initState();
    print('deal status ${dealResponseDto?.dealStatus}');

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    viewModel = GetMyShipmentDealDetailsViewModel(accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      // token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      dealCreatorEmail = loggedInState.user.email;
      // print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
    paymentProvider.getPaymentIntentId(widget.args.dealDto!.id.toString());

    if (accessTokenProvider.accessToken != null) {
      getMyShipmentDealDetails(
          dealId: widget.args.dealDto!.id.toString(),
          token: accessTokenProvider.accessToken!);
    }
  }

  void _showShipmentDealAcceptedBottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => ShipmentDealAcceptedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );

    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.of(context).pop();
    // });
  }

  Future<void> makePayment() async {
    try {
      // paymentIntent = await createPaymentIntent('6000', 'USD');
      // String id = paymentIntent!['id'];

      //STEP 2: Initialize Payment Sheet
      print('payment');

      isAccepted = false;
      if (paymentProvider.paymentIntentId != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret:
                    paymentProvider.clientSecret, //Gotten from payment intent
                style: ThemeMode.light,
                merchantDisplayName: 'Hatly'));

        //STEP 3: Display Payment sheet
        displayPaymentSheet(paymentProvider.paymentIntentId!);
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> displayPaymentSheet(String id) async {
    print('display strip');
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        setState(() {
          isPaid = true;
        });
        // Future.delayed(Duration(minutes: 1), () {
        //   capturePayments(id);
        // });
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)?.settings.arguments
    //     as MyShipmentDealDetailsArgument;
    var dealDto = widget.args.dealDto;
    print('status ${dealDto?.dealStatus}');
    var shipmentDto = widget.args.shipmentDto;
    dealId = dealDto!.id.toString();

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
          if (state is AcceptShipmentDealLoadingState) {
            isLoading = true;
          } else if (state is AcceptShipmentDealFailState) {
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
          if (state is RejectShipmentDealLoadingState) {
            isLoading = true;
          } else if (state is RejectShipmentDealFailState) {
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
          if (previous is AcceptShipmentDealLoadingState ||
              previous is RejectShipmentDealLoadingState) {
            isLoading = false;
          }
          if (current is AcceptShipmentDealSuccessState) {
            isAccepted = true;
            print('trueeee');
          }
          if (current is RejectShipmentDealSuccessState) {
            isRejected = true;
            print('rejected');
          }
          if (current is GetMyShipmentDealDetailsLoadingState ||
              current is GetMyShipmentDealDetailsFailState ||
              current is AcceptShipmentDealLoadingState ||
              current is AcceptShipmentDealFailState ||
              current is RejectShipmentDealLoadingState ||
              current is RejectShipmentDealFailState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetMyShipmentDealDetailsSuccessState) {
            dealResponseDto = state.responseDto.deal;
            if (dealResponseDto?.dealStatus?.toLowerCase() == 'accepted') {
              isAccepted = true;
            } else {
              isAccepted = false;
            }
            print('deall ${dealResponseDto?.creatorEmail}');
            print('accepted $isAccepted paid $isPaid');
            if (!isPaymentSheetOpened) {
              if (isAccepted && isPaid == false) {
                print('accept build: $isAccepted');
                isPaymentSheetOpened = true;
                makePayment();
              }
            }
          }

          if (state is AcceptShipmentDealSuccessState) {
            acceptShipmentDealResponseDto = state.responseDto;
            paymentIntentId = acceptShipmentDealResponseDto?.paymentIntentId;
            clientSecret = acceptShipmentDealResponseDto?.clientSecret;
            paymentProvider.setPaymentIntentId(
                paymentIntentId, clientSecret, dealId);
            if (isAccepted) {
              print('accept build: $isAccepted');

              makePayment();
            }
            print('accept: $isAccepted');
          }
          return Stack(
            children: [
              Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  resizeToAvoidBottomInset: true,
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
                                await getMyShipmentDealDetails(
                                    dealId: dealId,
                                    token: accessTokenProvider.accessToken!);
                                setState(() {});
                              },
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  MyShipmentCard(
                                    title: shipmentDto!.title!,
                                    from: shipmentDto.from!,
                                    to: shipmentDto.to!,
                                    date: DateFormat('dd MMMM yyyy')
                                        .format(shipmentDto.expectedDate!),
                                    shipmentDto: shipmentDto,
                                    shipImage: Image.network(
                                      shipmentDto
                                          .items!.first.photos!.first.photo!,
                                      fit: BoxFit.fitWidth,
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
                                                    card.Card(
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
                                                  '${dealResponseDto?.counterReward} \$',
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
                                                    '${dealResponseDto?.hatlyFees} \$',
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
                                                    '${dealResponseDto?.paymentFees} \$',
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
                                          onPressed: () => dealResponseDto
                                                          ?.dealStatus ==
                                                      'accepted' ||
                                                  dealResponseDto?.dealStatus ==
                                                      'rejected'
                                              ? dealResponseDto?.dealStatus ==
                                                      'accepted'
                                                  ? ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                          'You cannot accept the deal twice',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : dealResponseDto
                                                              ?.dealStatus ==
                                                          'rejected'
                                                      ? ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'You cannot reject an accepted deal',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      : ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'You cannot reject an ${dealResponseDto?.dealStatus} deal',
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                              : accessTokenProvider
                                                          .accessToken !=
                                                      null
                                                  ? dealDto.creatorEmail ==
                                                          dealCreatorEmail
                                                      ? null
                                                      : acceptShipmentDeal(
                                                          dealId: dealId,
                                                          token:
                                                              accessTokenProvider
                                                                  .accessToken)
                                                  : null,
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
                                            dealDto.creatorEmail !=
                                                    dealCreatorEmail
                                                ? 'accepted' ==
                                                            dealDto.dealStatus!
                                                                .toLowerCase() ||
                                                        'rejected' ==
                                                            dealDto.dealStatus!
                                                                .toLowerCase()
                                                    ? ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                            'You cannot send counter offer for an ${dealResponseDto?.dealStatus} deal',
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    : showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AnimatedAlertDialog(
                                                            dialogContent:
                                                                CounterOfferDialog(
                                                              sendReward:
                                                                  sendCounterReward,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                : showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AnimatedAlertDialog(
                                                        dialogContent:
                                                            ConfirmCancelDealDialog(
                                                          confirmCancellation:
                                                              cancelDeal,
                                                        ),
                                                      );
                                                    },
                                                  );
                                          },
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              dealDto.creatorEmail ==
                                                      dealCreatorEmail
                                                  ? 'Cancel'
                                                  : 'Counter offer',
                                              style: const TextStyle(
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
                                              side: const BorderSide(
                                                  color: Colors.red, width: 1),
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () => dealResponseDto
                                                          ?.dealStatus ==
                                                      'accepted' ||
                                                  dealResponseDto?.dealStatus ==
                                                      'rejected'
                                              ? dealResponseDto?.dealStatus ==
                                                      'accepted'
                                                  ? ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                          'You cannot reject an accepted deal',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : dealResponseDto
                                                              ?.dealStatus ==
                                                          'rejected'
                                                      ? ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'You cannot reject the deal twice',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      : ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'You cannot reject an ${dealResponseDto?.dealStatus} deal',
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                              : accessTokenProvider
                                                          .accessToken !=
                                                      null
                                                  ? dealDto.creatorEmail ==
                                                          dealCreatorEmail
                                                      ? null
                                                      : viewModel.rejectShipmentDeal(
                                                          dealId: dealId,
                                                          token:
                                                              accessTokenProvider
                                                                  .accessToken!)
                                                  : null,
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
                            await getMyShipmentDealDetails(
                                dealId: dealId,
                                token: accessTokenProvider.accessToken!);
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
                                      title: shipmentDto!.title!,
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
                                                      card.Card(
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
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                              const BoxDecoration(
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
                                                                SizedBox(
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
                                                                SizedBox(
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
                                                              const BoxDecoration(
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
                                                                SizedBox(
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
                                                                SizedBox(
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
                                            color: const Color.fromRGBO(
                                                47, 40, 77, 30)),
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
                                                    '${dealResponseDto?.counterReward} \$',
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
                                                margin: const EdgeInsets.only(
                                                    top: 10),
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
                                                      '${dealResponseDto?.hatlyFees} \$',
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
                                                margin: const EdgeInsets.only(
                                                    top: 10),
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
                                                      '${dealResponseDto?.paymentFees} \$',
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
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 51, 114, 53),
                                                    width: 1),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 51, 114, 53),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 12)),
                                            onPressed: () => dealResponseDto
                                                            ?.dealStatus ==
                                                        'accepted' ||
                                                    dealResponseDto
                                                            ?.dealStatus ==
                                                        'rejected'
                                                ? ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'The deal is already accepted',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                : accessTokenProvider
                                                            .accessToken !=
                                                        null
                                                    ? viewModel.acceptShipmentDeal(
                                                        dealId: dealId,
                                                        token:
                                                            accessTokenProvider
                                                                .accessToken!)
                                                    : null,
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
                                            onPressed: () => dealResponseDto
                                                            ?.dealStatus ==
                                                        'accepted' ||
                                                    dealResponseDto?.dealStatus ==
                                                        'rejected'
                                                ? dealResponseDto?.dealStatus ==
                                                        'accepted'
                                                    ? ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                        const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                            'You cannot accept the deal twice',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    : dealResponseDto?.dealStatus ==
                                                            'rejected'
                                                        ? ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                'You cannot reject an accepted deal',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        : ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                'You cannot reject an ${dealResponseDto?.dealStatus} deal',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                : accessTokenProvider
                                                            .accessToken !=
                                                        null
                                                    ? viewModel.acceptShipmentDeal(
                                                        dealId: dealId,
                                                        token:
                                                            accessTokenProvider
                                                                .accessToken!)
                                                    : null,
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
                                              dealDto.creatorEmail !=
                                                      dealCreatorEmail
                                                  ? 'accepted' ==
                                                              dealDto
                                                                  .dealStatus!
                                                                  .toLowerCase() ||
                                                          'rejected' ==
                                                              dealDto
                                                                  .dealStatus!
                                                                  .toLowerCase()
                                                      ? ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'You cannot send counter offer for an ${dealResponseDto?.dealStatus} deal',
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      : showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AnimatedAlertDialog(
                                                              dialogContent:
                                                                  CounterOfferDialog(
                                                                sendReward:
                                                                    sendCounterReward,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AnimatedAlertDialog(
                                                          dialogContent:
                                                              ConfirmCancelDealDialog(
                                                            confirmCancellation:
                                                                cancelDeal,
                                                          ),
                                                        );
                                                      },
                                                    );
                                            },
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                dealDto.creatorEmail ==
                                                        dealCreatorEmail
                                                    ? 'Cancel'
                                                    : 'Counter offer',
                                                style: const TextStyle(
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
                                                side: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1),
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12)),
                                            onPressed: () => dealResponseDto
                                                            ?.dealStatus ==
                                                        'accepted' ||
                                                    dealResponseDto
                                                            ?.dealStatus ==
                                                        'rejected'
                                                ? ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'You cannot reject an accepted deal',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                : accessTokenProvider
                                                            .accessToken !=
                                                        null
                                                    ? viewModel.rejectShipmentDeal(
                                                        dealId: dealId,
                                                        token:
                                                            accessTokenProvider
                                                                .accessToken!)
                                                    : null,
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

  void sendCounterReward(double reward) {
    viewModel.makeCounterOffer(
        token: accessTokenProvider.accessToken!,
        dealId: widget.args.dealDto!.id!,
        reward: reward);
  }

  void acceptShipmentDeal({String? dealId, String? token}) {
    viewModel.acceptShipmentDeal(dealId: dealId!, token: token!);
  }

  void cancelDeal() {
    viewModel.cancelShipmentDeal(
        dealId: widget.args.dealDto!.id!,
        token: accessTokenProvider.accessToken!);
  }

  String substractDates(DateTime dateTime) {
    DateTime dateNow = DateTime.now();

    var substractedDate = dateNow.difference(dateTime);

    var daysAgo = substractedDate.inDays;

    return daysAgo.toString();
  }
}
