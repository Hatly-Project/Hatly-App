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
import 'package:hatly/ui/components/my_shipment_card.dart';
import 'package:hatly/ui/components/my_shipments_shimmer_card.dart';
import 'package:hatly/ui/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/ui/home/tabs/shipments/my_shipments_screen_viewmodel.dart';
import 'package:hatly/ui/home/tabs/shipments/shipments_bottom_sheet.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/item_dto.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';

class MyShipmentsTab extends StatefulWidget {
  static const String routeName = 'MyShipments';

  MyShipmentsTab({super.key});

  @override
  State<MyShipmentsTab> createState() => _MyShipmentsTabState();
}

class _MyShipmentsTabState extends State<MyShipmentsTab> {
  MyShipmentsScreenViewModel viewModel = MyShipmentsScreenViewModel();
  List<ShipmentDto> myShipments = [];
  late String token;
  ScrollController scrollController = ScrollController();
  Image? shipImage;
  late CountriesDto countries;

  bool isMyshipmentEmpty = false, shimmerIsLoading = false;
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

    // Check for cached shipments when initializing
    getCachedMyShipments().then((cachedShipments) async {
      if (cachedShipments.isNotEmpty) {
        print('exist');
        setState(() {
          myShipments = cachedShipments;
        });
      } else {
        await viewModel.getMyShipments(token: token);
        print('no Exist'); // Fetch from API if cache is empty
      }
    });
  }

  // a method for caching the shipments list
  Future<void> cacheMyShipments(List<ShipmentDto> shipments) async {
    final box = await Hive.openBox(
        'shipments_${loggedInState.user.email!.replaceAll('@', '_at_')}');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final shipmentMaps =
        shipments.map((shipment) => shipment.toJson()).toList();

    // Clear existing data and store the new data in the box
    print('done caching');
    await box.clear();
    await box.addAll(shipmentMaps);
  }

  Future<List<ShipmentDto>> getCachedMyShipments() async {
    final box = await Hive.openBox(
        'shipments_${loggedInState.user.email!.replaceAll('@', '_at_')}');
    final shipmentMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final shipments = shipmentMaps
        .map((shipmentMap) => ShipmentDto.fromJson(shipmentMap))
        .toList();

    return shipments;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    countries = args.countriesFlagsDto;
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is CreateShipLoadingState) {
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
        } else if (state is CreateShipFailState) {
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
        if (previous is CreateShipLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (previous is GetMyShipmentsLoadingState) {
          shimmerIsLoading = false;
        }
        if (current is CreateShipLoadingState ||
            current is CreateShipFailState ||
            current is GetMyShipmentsLoadingState ||
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
            clearData();
            print('empty');
          } else {
            isMyshipmentEmpty = false;
            print(
                'photoooo ${myShipments.first.items!.first.photos!.first.photo!}');
            cacheMyShipments(myShipments);
          }
          shimmerIsLoading = false;
        }
        if (state is CreateShipSuccessState) {
          print('done create ${state.responseDto.shipment?.title}');
          myShipments.add(state.responseDto.shipment!);
          isMyshipmentEmpty = false;
          cacheMyShipments(myShipments);
        }
        return Platform.isIOS
            ? Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'My Shipments',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () =>
                          showShipmentBottomSheet(context, countries),
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
                        await viewModel.getMyShipments(token: token);
                        cacheMyShipments(myShipments);
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('images/no_shipments.png'),
                                      Text(
                                        "You don't have any shipments, press the add button to add a shipment",
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
                                    (context, index) => MyShipmentCard(
                                          title: myShipments[index].title!,
                                          from: myShipments[index].from!,
                                          to: myShipments[index].to!,
                                          date: DateFormat('dd MMMM yyyy')
                                              .format(myShipments[index]
                                                  .expectedDate!),
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
                  await viewModel.getMyShipments(token: token);
                  cacheMyShipments(myShipments);
                  setState(() {});
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      'My Shipments',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () =>
                            showShipmentBottomSheet(context, countries),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  body: isMyshipmentEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('images/no_shipments.png'),
                                Text(
                                  "You don't have any shipments, press the add button to add a shipment",
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
                          itemCount: myShipments.length,
                          itemBuilder: (context, index) => MyShipmentCard(
                            title: myShipments[index].title!,
                            from: myShipments[index].from!,
                            to: myShipments[index].to!,
                            date: DateFormat('dd MMMM yyyy')
                                .format(myShipments[index].expectedDate!),
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

  void clearData() async {
    final box = await Hive.openBox(
        'shipments_${loggedInState.user.email!.replaceAll('@', '_at_')}');

    // Clear existing data and store the new data in the box
    print('cleared');
    await box.clear();
    await box.close();
  }

  void done(
      String fromCountry,
      String fromState,
      String toState,
      String toCountry,
      String date,
      String name,
      String note,
      String bonus,
      List<ItemDto> items) {
    viewModel.create(
        token: token,
        from: fromCountry,
        to: toCountry,
        date: date,
        title: name,
        note: note,
        reward: double.tryParse(bonus),
        items: items);
    print('done ship');
    print(
        '$name , $note , $fromCountry , $fromState , $toCountry , $toState , $bonus , $date itemWeighttt ${items.first.weight}');
    setState(() {});
    Navigator.of(context).pop();
  }

  void showShipmentBottomSheet(
      BuildContext context, CountriesDto countriesDto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => AddShipmentBottomSheet(
        onError: onError,
        done: done,
        countriesDto: countriesDto,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
