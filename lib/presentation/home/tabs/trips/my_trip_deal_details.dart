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
import 'package:hatly/domain/models/trip_deal_dto.dart';
import 'package:hatly/presentation/components/animated_alert_dialog.dart';
import 'package:hatly/presentation/components/confirm_cancel_deal_dialog.dart';
import 'package:hatly/presentation/components/counter_offer_dialog.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:hatly/presentation/components/my_trip_card.dart';
import 'package:hatly/presentation/components/my_trip_deal_card.dart';
import 'package:hatly/presentation/components/shimmer_card.dart';
import 'package:hatly/presentation/components/shipment_card_for_trip_deal_details.dart';
import 'package:hatly/presentation/components/trip_card_details.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_argument.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deal_details_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_accepted_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_tracking_screen.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_trcking_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_deal_details_argument.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_deal_details_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_accepted_bottom_sheet.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/providers/payment_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyTripDealDetails extends StatefulWidget {
  static const routeName = 'MyTripDealDetails';
  MyTripDealDetailsArgument args;
  MyTripDealDetails({required this.args});

  @override
  State<MyTripDealDetails> createState() => _MyTripDealDetailsState();
}

class _MyTripDealDetailsState extends State<MyTripDealDetails> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late LoggedInState loggedInState;
  // late String token;
  late int dealId;
  bool isPaid = false;
  String? paymentIntentId, clientSecret;
  TripDealDto? dealResponseDto;
  late String? dealCreatorEmail;
  AcceptOrRejectShipmentDealResponseDto? acceptShipmentDealResponseDto;
  bool isAccepted = false, isRejected = false, isPaymentSheetOpened = false;

  late GetMyTripDealDetailsViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  late PaymentProvider paymentProvider;
  Future<void> getMyTripDealDetails(
      {required int dealId, required String token}) async {
    if (accessTokenProvider.accessToken != null) {
      return viewModel.getMyTripDealDetails(dealId: dealId, token: token);
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
    viewModel = GetMyTripDealDetailsViewModel(accessTokenProvider);
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
    paymentProvider.getPaymentIntentId(widget.args.deal!.id.toString());

    if (accessTokenProvider.accessToken != null) {
      getMyTripDealDetails(
          dealId: widget.args.deal!.id!,
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
    var dealDto = widget.args.deal;
    print('status ${dealDto?.dealStatus}');
    var tripdto = widget.args.tripsDto;
    dealId = dealDto!.id!;

    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is GetMyTripDealDetailsLoadingState) {
            isLoading = true;
          } else if (state is GetMyTripDealDetailsFailState) {
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
          if (state is AcceptTripDealLoadingState) {
            isLoading = true;
          } else if (state is AcceptTripDealFailState) {
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
          if (state is RejectTripDealLoadingState) {
            isLoading = true;
          } else if (state is RejectTripDealFailState) {
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
          if (previous is GetMyTripDealDetailsLoadingState) {
            isLoading = false;
          }
          if (previous is AcceptTripDealLoadingState ||
              previous is RejectTripDealLoadingState) {
            isLoading = false;
          }
          if (current is AcceptTripDealSuccessState) {
            isAccepted = true;
            print('trueeee');
          }
          if (current is RejectTripDealSuccessState) {
            isRejected = true;
            print('rejected');
          }
          if (current is GetMyTripDealDetailsLoadingState ||
              current is GetMyTripDealDetailsFailState ||
              current is AcceptTripDealLoadingState ||
              current is AcceptTripDealFailState ||
              current is RejectTripDealLoadingState ||
              current is RejectTripDealFailState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetMyTripDealDetailsSuccessState) {
            dealResponseDto = state.responseDto.deal;
            print('statusssss ${dealResponseDto!.dealStatus}');
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

          if (state is AcceptTripDealSuccessState) {
            // paymentProvider.setPaymentIntentId(
            //     paymentIntentId, clientSecret, dealId.toString());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (isAccepted) {
                _showTripDealAcceptedBottomSheet(context);
              }
            });
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
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //     context, ShipmentDealTrackingScreen.routeName,
                          //     arguments: ShipmentDealTrackingScreenArguments(
                          //         dealdto: widget.args.tripsDto));
                        },
                        child: Text(
                          'Tracking',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  body: Platform.isIOS
                      ? CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          slivers: [
                            CupertinoSliverRefreshControl(
                              onRefresh: () async {
                                await getMyTripDealDetails(
                                    dealId: dealId,
                                    token: accessTokenProvider.accessToken!);
                                setState(() {});
                              },
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  MyTripCard(
                                    origin: tripdto!.origin,
                                    destination: tripdto.destination,
                                    tripsDto: tripdto,
                                    availableWeight: tripdto.available,
                                    consumedWeight: tripdto.consumed,
                                    date: DateFormat('dd MMMM yyyy')
                                        .format(tripdto.departDate!),
                                  ),
                                  isLoading
                                      ? ShimmerCard()
                                      : MyTripDealCard(
                                          tripsDto: tripdto,
                                          dealDto: dealResponseDto!,
                                          isFromTripDealDetails: true,
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
                                                    '${dealResponseDto?.fees} \$',
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
                                                  ? ScaffoldMessenger.of(context)
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
                                                      : acceptTripDeal(
                                                          dealId:
                                                              dealId.toString(),
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
                                                  : dealResponseDto?.dealStatus ==
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
                                              : accessTokenProvider.accessToken !=
                                                      null
                                                  ? dealDto.creatorEmail ==
                                                          dealCreatorEmail
                                                      ? null
                                                      : viewModel.rejectTripDeal(
                                                          dealId:
                                                              dealId.toString(),
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
                            await getMyTripDealDetails(
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
                                    MyTripCard(
                                      origin: tripdto!.origin,
                                      destination: tripdto.destination,
                                      tripsDto: tripdto,
                                      availableWeight: tripdto.available,
                                      consumedWeight: tripdto.consumed,
                                      date: DateFormat('dd MMMM yyyy')
                                          .format(tripdto.departDate!),
                                    ),
                                    isLoading
                                        ? ShimmerCard()
                                        : MyTripDealCard(
                                            tripsDto: tripdto,
                                            dealDto: dealResponseDto!,
                                            isFromTripDealDetails: true,
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
                                                    '${dealResponseDto?.finalReward} \$',
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
                                                      '${dealResponseDto?.fees} \$',
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
                                                    : dealResponseDto
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
                                                        : ScaffoldMessenger.of(context)
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
                                                    ? dealDto.creatorEmail ==
                                                            dealCreatorEmail
                                                        ? null
                                                        : acceptTripDeal(
                                                            dealId: dealId
                                                                .toString(),
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
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    : dealResponseDto
                                                                ?.dealStatus ==
                                                            'rejected'
                                                        ? ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                'You cannot reject the deal twice',
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
                                                        : ScaffoldMessenger.of(context)
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
                                                    ? dealDto.creatorEmail ==
                                                            dealCreatorEmail
                                                        ? null
                                                        : viewModel.rejectTripDeal(
                                                            dealId: dealId
                                                                .toString(),
                                                            token: accessTokenProvider
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
        dealId: widget.args.deal!.id!,
        reward: reward);
  }

  void acceptTripDeal({String? dealId, String? token}) {
    viewModel.acceptTripDeal(dealId: dealId!, token: token!);
  }

  void cancelDeal() {
    // viewModel.ca(
    //     dealId: widget.args.dealDto!.id!,
    //     token: accessTokenProvider.accessToken!);
  }

  void _showTripDealAcceptedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      useSafeArea: true,
      builder: (context) => TripDealAcceptedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
    isAccepted = false;
  }

  String substractDates(DateTime dateTime) {
    DateTime dateNow = DateTime.now();

    var substractedDate = dateNow.difference(dateTime);

    var daysAgo = substractedDate.inDays;

    return daysAgo.toString();
  }
}
