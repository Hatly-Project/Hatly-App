import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_screen-viewmodel.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';

class MyShipmentDeals extends StatefulWidget {
  const MyShipmentDeals({super.key});

  @override
  State<MyShipmentDeals> createState() => _ShipmentDealsState();
}

class _ShipmentDealsState extends State<MyShipmentDeals> {
  ScrollController scrollController = ScrollController();
  late LoggedInState loggedInState;
  MyShipmentDetailsScreenViewModel viewModel =
      MyShipmentDetailsScreenViewModel();

  List<DealDto>? deals;
  bool isMyshipmentDealsEmpty = false;
  late String token;
  bool isLoading = true;

  Future<void> getMyshipmentDeals(
      {required String token, required int shipmentId}) async {
    await viewModel.getMyshipmentDeals(token: token, shipmentId: shipmentId);
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
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments
        as MyShipmentDetailsArguments;
    var shipment = args.shipmentDto;
    getMyshipmentDeals(token: token, shipmentId: shipment.id!);

    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is MyshipmentDealsLoadingState) {
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
        } else if (state is MyshipmentDealsFailState) {
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
        if (previous is MyshipmentDealsLoadingState) {
          // DialogUtils.hideDialog(context);
          isLoading = false;
        }
        if (current is MyshipmentDealsLoadingState ||
            current is MyshipmentDealsFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MyshipmentDealsSuccessState) {
          print('getDeals success');
          deals = state.responseDto.deals ?? [];
          if (deals!.isEmpty) {
            isMyshipmentDealsEmpty = true;
          } else {
            isMyshipmentDealsEmpty = false;
          }
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // CupertinoSliverRefreshControl(
                  //   onRefresh: () async {
                  //     await viewModel.getMyShipments(token: token);
                  //     cacheMyShipments(myShipments);
                  //     setState(() {});
                  //   },
                  // ),
                  // shimmerIsLoading
                  //     ?
                  //     SliverList(
                  //         delegate: SliverChildBuilderDelegate(
                  //             (context, index) => MyShipmentShimmerCard(),
                  //             childCount: 5),
                  //       )
                  // : isMyshipmentEmpty
                  //     ?
                  isMyshipmentDealsEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
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
                                  "You don't have any deals for this shipment",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Container(),
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
        );
      },
    );
  }
}
