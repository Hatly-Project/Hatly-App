import 'dart:convert';
import 'dart:ffi' as size;
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/countries_list.dart';
import 'package:hatly/presentation/components/countries_list_bottom_sheet.dart';
import 'package:hatly/presentation/components/custom_fields_for_search.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/components/horizontal_shipment_card.dart';
import 'package:hatly/presentation/components/shimmer_card.dart';
import 'package:hatly/presentation/components/trip_card.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/home/search_result_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/login/login_screen_arguments.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/shipment_dto.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../components/shipment_card.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = 'SearchResult';

  const SearchResultScreen();
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen>
    with TickerProviderStateMixin {
  // late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool shipmentsIsEmpty = false;
  bool tripsIsEmpty = true;
  int selectedTab = 0;
  List<ShipmentDto> shipments = [];
  List<TripsDto> trips = [];
  FlutterSecureStorage storage = FlutterSecureStorage();
  TextEditingController fromController = TextEditingController(text: '');
  TextEditingController toController = TextEditingController(text: '');

  // String token = '';
  final GlobalKey shipmentFromKey = GlobalKey();
  final GlobalKey receivingInKey = GlobalKey();
  final GlobalKey shipmentCardKey = GlobalKey();

  bool _isShipmentFromClicked = false,
      _isReceivingInClicked = false,
      _isShipmentsClicked = true,
      _isTripsClicked = false;
  int? totalShipmentsPage,
      currentShipmentsPage = 1,
      totalTripsPage,
      totalTripsData,
      currentTripsPage = 1,
      totalShipmentsData;
  SearchResultScreenArguments? args;
  late HomeScreenViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  bool shimmerIsLoading = true,
      isShipmentPaginationLoading = false,
      isTripPaginationLoading = false;
  var _isButtonEnabled = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  List<CountriesStatesDto> filteredCountries = [];
  String? fromCountry,
      fromCountryFlag,
      toCountryName,
      toCountryFlag,
      fromCountryIso,
      toCountryIso;
  late List<StateDto> fromStatesList, toStatesList;
  bool? isShipmentSearch, isTripSearch;

  @override
  void initState() {
    super.initState();
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = HomeScreenViewModel(accessTokenProvider);
//     UserProvider userProvider =
//         BlocProvider.of<UserProvider>(context, listen: false);

// // Check if the current state is LoggedInState and then access the token
//     if (userProvider.state is LoggedInState) {
//       LoggedInState loggedInState = userProvider.state as LoggedInState;
//       // token = loggedInState.accessToken;
//       // Now you can use the 'token' variable as needed in your code.
//       // getAccessToken(accessTokenProvider);
//     } else {
//       print(
//           'User is not logged in.'); // Handle the scenario where the user is not logged in.
//     }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // if (_isShipmentsClicked) {
    //   getShipments();
    // } else {
    //   getTrips();
    // }
  }

  @override
  void dispose() {
    // tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Future<String> getAccessToken(AccessTokenProvider accessTokenProvider) async {
  //   // String? accessToken = await storage.read(key: 'accessToken');

  //   if (accessTokenProvider.accessToken != null) {
  //     token = accessTokenProvider.accessToken!;
  //     // viewModel.create(accessTokenProvider.accessToken!);
  //     print('access $token');
  //   }

  //   setState(() {});
  //   return token;
  // }

  // a method for caching the shipments list
  Future<void> cacheShipments(List<ShipmentDto> shipments) async {
    final box = await Hive.openBox('shipments');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final shipmentMaps =
        shipments.map((shipment) => shipment.toJson()).toList();

    // Clear existing data and store the new data in the box
    await box.clear();
    await box.addAll(shipmentMaps);
  }

  Future<List<ShipmentDto>> getCachedShipments() async {
    final box = await Hive.openBox('shipments');
    final shipmentMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final shipments = shipmentMaps
        .map((shipmentMap) => ShipmentDto.fromJson(shipmentMap))
        .toList();

    return shipments;
  }

  // a method for caching the trips list
  Future<void> cacheTrips(List<TripsDto> trips) async {
    final box = await Hive.openBox('trips');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final tripsMaps = trips.map((trip) => trip.toJson()).toList();

    // Clear existing data and store the new data in the box
    await box.clear();
    await box.addAll(tripsMaps);
  }

  Future<List<TripsDto>> getChachedtrips() async {
    final box = await Hive.openBox('trips');
    final tripsMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final trips =
        tripsMaps.map((tripsMaps) => TripsDto.fromJson(tripsMaps)).toList();

    return trips;
  }

  OverlayEntry? _overlayEntry;

  void _hideOverlay() {
    print('sasas');
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isShipmentFromClicked = false;
      _isReceivingInClicked = false;
    });
  }

  void _showOverlay(BuildContext context, String type, GlobalKey key) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    _overlayEntry = _createOverlayEntry(context, type, key);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(
      BuildContext context, String type, GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: offset.dy + size.height,
              left: offset.dx,
              width: size.width,
              child: SlideTransition(
                  position: _animation,
                  child: CountriesList(
                    countries: args!.countriesFlagsDto,
                    selectFromCountry:
                        _isShipmentFromClicked ? selectFromCountry : null,
                    selectToCountry:
                        _isReceivingInClicked ? selectDestinationCountry : null,
                    hideOverLay: _hideOverlay,
                  )),
            ));
  }

  void selectFromCountry(String selectedCountry) {
    _hideOverlay();
    var index = args!.countriesFlagsDto.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = args!.countriesFlagsDto.countries![index!].states;

    setState(() {
      fromCountry = selectedCountry;
      // fromCityValue = '';
      fromCountryFlag = args!
          .countriesFlagsDto
          .countries![args!.countriesFlagsDto.countries!
              .indexWhere((country) => country.name == fromCountry)]
          .flag;
      fromStatesList = countryStates!;
      if (fromCountry != null && toCountryName != null) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('from $fromCountry');
  }

  void selectDestinationCountry(String selectedCountry) {
    _hideOverlay();
    var index = args!.countriesFlagsDto.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = args!.countriesFlagsDto.countries![index!].states;

    setState(() {
      toCountryName = selectedCountry;
      // fromCityValue = '';
      toCountryFlag = args!
          .countriesFlagsDto
          .countries![args!.countriesFlagsDto.countries!
              .indexWhere((country) => country.name == toCountryName)]
          .flag;
      toStatesList = countryStates!;
      if (fromCountry != null && toCountryName != null) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('to $toCountryName');
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //       statusBarColor: Colors.transparent,
    //       systemNavigationBarColor: Colors.transparent,
    //       statusBarIconBrightness: Brightness.dark),
    // );
    UserProvider userProvider = BlocProvider.of<UserProvider>(context);
    args = ModalRoute.of(context)!.settings.arguments
        as SearchResultScreenArguments;
    fromCountry = args!.fromCountry;
    fromCountryFlag = args!.fromCountryFlag;
    toCountryName = args!.toCountryName;
    toCountryFlag = args!.toCountryFlag;
    fromCountryIso = args!.fromCountryIso;
    toCountryIso = args!.toCountryIso;
    totalShipmentsPage = args!.totalShipmentsPage;
    currentShipmentsPage = args!.currentShipmentsPage;
    isShipmentSearch = args!.isShipmentSearch;
    isTripSearch = args!.isTripSearch;
    totalShipmentsData = args!.totalData;
    if (isShipmentSearch!) {
      shipments = args!.shipments!;
      setState(() {});
    } else if (isTripSearch!) {
      trips = args!.trips!;
      _isTripsClicked = true;
      isTripSearch = false;
      setState(() {});
    }
    if (shipments.isNotEmpty || shipments.isEmpty) {
      shimmerIsLoading = false;
      setState(() {});
    }
    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is GetAllShipsLoadingState) {
            print(state);
            shimmerIsLoading = true;
            // if (Platform.isIOS) {
            //   DialogUtils.showDialogIos(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // } else {
            //   DialogUtils.showDialogAndroid(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // }
          } else if (state is GetAllShipsFailState) {
            print('status code ${state.statusCode}');
            if (Platform.isIOS) {
              DialogUtils.showDialogIos(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  statusCode: state.statusCode,
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'Login',
                        arguments:
                            LoginScreenArguments(args!.countriesFlagsDto));
                  },
                  context: context);
            } else {
              DialogUtils.showDialogAndroid(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'Login',
                        arguments:
                            LoginScreenArguments(args!.countriesFlagsDto));
                  },
                  statusCode: state.statusCode,
                  context: context);
            }
          }

          if (state is GetAllTripsLoadingState) {
            shimmerIsLoading = true;
            // ListView.builder(
            //   itemCount: 2,
            //   itemBuilder: (context, index) => const ShimmerCard(),
            // );
            // if (Platform.isIOS) {
            //   DialogUtils.showDialogIos(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // } else {
            //   DialogUtils.showDialogAndroid(
            //       alertMsg: 'Loading',
            //       alertContent: state.loadingMessage,
            //       context: context);
            // }
          } else if (state is GetAllTripsFailState) {
            if (Platform.isIOS) {
              DialogUtils.showDialogIos(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  statusCode: state.statusCode,
                  context: context);
            } else {
              DialogUtils.showDialogAndroid(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  statusCode: state.statusCode,
                  context: context);
            }
          }
        },
        listenWhen: (previous, current) {
          if (previous is GetAllShipsLoadingState ||
              previous is GetAllTripsLoadingState) {
            shimmerIsLoading = false;
            // DialogUtils.hideDialog(context);
          }
          if (current is GetAllShipsLoadingState ||
              current is GetAllShipsFailState ||
              current is GetAllTripsLoadingState ||
              current is RefreshTokenFailState ||
              current is GetAllTripsFailState) {
            print(current);
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetAllShipsSuccessState) {
            print('shipment from build ${state.shipmentDto.length}');
            shipments = state.shipmentDto;
            currentShipmentsPage = state.currentPage;
            totalShipmentsPage = state.totalPages;
            print('ship length ${shipments.length}');
            if (shipments.isEmpty) {
              shipmentsIsEmpty = true;
              print("emptyyyy");
            } else {
              shipmentsIsEmpty = false;
              // cacheShipments(shipments);
              print('success ${shipments[0].items![0].photos!.first}');
            }
            shimmerIsLoading = false;
          }
          if (state is GetAllTripsSuccessState) {
            print('tripss');
            trips = state.tripsDto;
            currentTripsPage = state.currentPage;
            totalTripsPage = state.totalPages;
            totalTripsData = state.totalData;
            if (trips.isEmpty) {
              tripsIsEmpty = true;
              print('trips empty');
            } else {
              print('tripss success');
              tripsIsEmpty = false;
              // cacheTrips(trips);
            }
            shimmerIsLoading = false;
          }
          return GestureDetector(
            onTap: _overlayEntry == null ? null : _hideOverlay,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height:
                    //     MediaQuery.sizeOf(context).height * .385,
                    // margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Column(
                              children: [
                                Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: Color(0xFFD6D6D6)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _isShipmentFromClicked
                                          ? Expanded(
                                              flex: 1,
                                              child: Material(
                                                key: shipmentFromKey,
                                                elevation:
                                                    10.0, // Elevation value
                                                color: Colors.white,

                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child: Image
                                                                      .asset(
                                                                    'images/takeoff.png',
                                                                    width: 17,
                                                                    height: 17,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Shipment From',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayMedium,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              width: 130,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  'Select a country',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayLarge
                                                                      ?.copyWith(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .keyboard_arrow_right_rounded,
                                                          color:
                                                              Color(0xFFADADAD),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            )
                                          : fromCountry == null
                                              ? Expanded(
                                                  flex: 1,
                                                  key: shipmentFromKey,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child:
                                                          CustomFormFieldForSeaarch(
                                                        controller:
                                                            fromController,
                                                        // key:
                                                        //     shipmentFromKey,
                                                        readOnly: true,
                                                        hint: 'Shipment From',
                                                        onTap: () {
                                                          _isShipmentFromClicked =
                                                              !_isShipmentFromClicked;
                                                          print(
                                                              _isShipmentFromClicked);
                                                          setState(() {
                                                            if (_overlayEntry !=
                                                                null) {
                                                              _overlayEntry
                                                                  ?.remove();
                                                              _overlayEntry =
                                                                  null;
                                                              _isReceivingInClicked =
                                                                  false;
                                                            }
                                                          });
                                                          // _overlayEntry
                                                          //     ?.remove();

                                                          _showOverlay(
                                                              context,
                                                              'shipment from',
                                                              shipmentFromKey);

                                                          // showFromCountriesListBottomSheet(
                                                          //     context,
                                                          //     args!
                                                          //         .countriesFlagsDto);
                                                        },
                                                        prefixIcon: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 15),
                                                          child: Image.asset(
                                                            'images/takeoff.png',
                                                            width: 17,
                                                            height: 17,
                                                          ),
                                                        ),
                                                        suffixICon: Container(
                                                          child: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            // size: 20,
                                                            color: Color(
                                                                0xFFADADAD),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Expanded(
                                                  flex: 1,
                                                  key: shipmentFromKey,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _isShipmentFromClicked =
                                                          !_isShipmentFromClicked;
                                                      setState(() {
                                                        if (_overlayEntry !=
                                                            null) {
                                                          _overlayEntry
                                                              ?.remove();
                                                          _overlayEntry = null;
                                                          _isReceivingInClicked =
                                                              false;
                                                        }
                                                      });
                                                      // _overlayEntry
                                                      //     ?.remove();
                                                      _showOverlay(
                                                          context,
                                                          'shipment from',
                                                          shipmentFromKey);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10),
                                                                    child: Image
                                                                        .asset(
                                                                      'images/takeoff.png',
                                                                      width: 17,
                                                                      height:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 118,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        'Shipment From',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displayMedium,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    child: Image
                                                                        .network(
                                                                      fromCountryFlag!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        .04,
                                                                  ),
                                                                  Container(
                                                                    width: 100,
                                                                    height: 20,
                                                                    child: Text(
                                                                      fromCountry!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayLarge
                                                                          ?.copyWith(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            color: Color(
                                                                0xFFADADAD),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15),
                                        child: Container(
                                          // margin: EdgeInsets.only(top: 10),
                                          width: double.infinity,
                                          height: 1,
                                          color: Color(0xFFD6D6D6),
                                        ),
                                      ),
                                      _isReceivingInClicked
                                          ? Expanded(
                                              flex: 1,
                                              child: Material(
                                                key: receivingInKey,
                                                elevation:
                                                    10.0, // Elevation value
                                                color: Colors.white,

                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child: Image
                                                                      .asset(
                                                                    'images/land.png',
                                                                    width: 17,
                                                                    height: 17,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'Receiving In',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayMedium,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              width: 130,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  'Select a country',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayLarge
                                                                      ?.copyWith(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .keyboard_arrow_right_rounded,
                                                          color:
                                                              Color(0xFFADADAD),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            )
                                          : toCountryName == null
                                              ? Expanded(
                                                  flex: 1,
                                                  key: receivingInKey,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child:
                                                          CustomFormFieldForSeaarch(
                                                        controller:
                                                            toController,
                                                        // key:
                                                        //     shipmentFromKey,
                                                        readOnly: true,
                                                        hint: 'Receiving In',
                                                        onTap: () {
                                                          _isReceivingInClicked =
                                                              !_isReceivingInClicked;
                                                          setState(() {});
                                                          if (_overlayEntry !=
                                                              null) {
                                                            _overlayEntry
                                                                ?.remove();
                                                            _overlayEntry =
                                                                null;
                                                          }
                                                          // _overlayEntry
                                                          //     ?.remove();
                                                          _showOverlay(
                                                              context,
                                                              'Receiving In',
                                                              receivingInKey);

                                                          // showFromCountriesListBottomSheet(
                                                          //     context,
                                                          //     args!
                                                          //         .countriesFlagsDto);
                                                        },
                                                        prefixIcon: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 15),
                                                          child: Image.asset(
                                                            'images/land.png',
                                                            width: 17,
                                                            height: 17,
                                                          ),
                                                        ),
                                                        suffixICon: Container(
                                                          child: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            // size: 20,
                                                            color: Color(
                                                                0xFFADADAD),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Expanded(
                                                  flex: 1,
                                                  key: receivingInKey,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _isReceivingInClicked =
                                                          !_isReceivingInClicked;
                                                      setState(() {});
                                                      // _overlayEntry
                                                      //     ?.remove();
                                                      if (_overlayEntry !=
                                                          null) {
                                                        _overlayEntry?.remove();
                                                        _overlayEntry = null;
                                                      }
                                                      _showOverlay(
                                                          context,
                                                          'Receiving In',
                                                          receivingInKey);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    // margin: EdgeInsets.only(right: 5),
                                                                    child: Image
                                                                        .asset(
                                                                      'images/land.png',
                                                                      width: 17,
                                                                      height:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 105,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          Text(
                                                                        'Receiving In',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displayMedium,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    child: Image
                                                                        .network(
                                                                      toCountryFlag!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        .04,
                                                                  ),
                                                                  Container(
                                                                    width: 100,
                                                                    height: 20,
                                                                    child: Text(
                                                                      toCountryName!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayLarge
                                                                          ?.copyWith(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            color: Color(
                                                                0xFFADADAD),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(18),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFD6D6D6),
                                                    width: 1)),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFD6D6D6),
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFD6D6D6),
                                                    width: 1)),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFD6D6D6),
                                                    width: 1)),
                                            label: Row(
                                              children: [
                                                Image.asset(
                                                  'images/date_icon.png',
                                                  width: 14,
                                                  height: 14,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'Before Date',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 3),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(18),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFD6D6D6),
                                                    width: 1)),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFD6D6D6),
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFD6D6D6),
                                                    width: 1)),
                                            label: Row(
                                              children: [
                                                Image.asset(
                                                  'images/weight_icob.png',
                                                  width: 14,
                                                  height: 14,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'Weight',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10, top: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 105,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: InkWell(
                                                  onTap: () async {
                                                    _isShipmentsClicked = true;
                                                    _isTripsClicked = false;
                                                    await viewModel
                                                        .getAllShipments(
                                                      token: accessTokenProvider
                                                          .accessToken,
                                                      from: fromCountryIso,
                                                      to: toCountryIso,
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    'Shipments',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20,
                                                            color: _isShipmentsClicked
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : const Color(
                                                                    0xFF848484)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 1.5,
                                              color: Color(0xFFD6D6D6),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: InkWell(
                                                  onTap: () async {
                                                    _isTripsClicked = true;
                                                    _isShipmentsClicked = false;

                                                    await viewModel.getAlltrips(
                                                        accessTokenProvider
                                                            .accessToken!,
                                                        isRefresh: true);
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    'Trips',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                          fontSize: 20,
                                                          color: _isTripsClicked
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : const Color(
                                                                  0xFF848484),
                                                        ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // margin: const EdgeInsets.only(top: 20),
                                          padding: EdgeInsets.only(left: 20),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                disabledBackgroundColor:
                                                    const Color(0xFFEEEEEE),
                                                minimumSize:
                                                    Size(double.infinity, 60),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                backgroundColor:
                                                    _isButtonEnabled
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : const Color(
                                                            0xFFEEEEEE),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12)),
                                            onPressed: _isButtonEnabled
                                                ? () {
                                                    // login();
                                                  }
                                                : null,
                                            child: Text(
                                              'Search',
                                              style: _isButtonEnabled
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .displayMedium
                                                      ?.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 127,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _isShipmentsClicked
                              ? '$totalShipmentsData Shipment found'
                              : '$totalTripsData Trip found',
                          style: _isButtonEnabled
                              ? Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)
                              : Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            if (_isShipmentsClicked) {
                              final box = await Hive.openBox('shipments');
                              await box.clear();
                              await box.close();
                              if (accessTokenProvider.accessToken != null) {
                                await viewModel.getAllShipments(
                                    token: accessTokenProvider.accessToken!,
                                    from: fromCountryIso,
                                    to: toCountryIso,
                                    isRefresh: true);
                              }
                              setState(() {
                                shipments.clear();
                              });
                            } else {
                              final box = await Hive.openBox('trips');
                              await box.clear();
                              await box.close();
                              if (accessTokenProvider.accessToken != null) {
                                await viewModel.getAlltrips(
                                    accessTokenProvider.accessToken!,
                                    isRefresh: true);
                              }
                              setState(() {
                                trips.clear();
                              });
                            }
                          },
                        ),
                        _isShipmentsClicked
                            ? shimmerIsLoading
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => const ShimmerCard(),
                                      childCount: 2,
                                    ),
                                  )
                                : shipmentsIsEmpty || shipments.isEmpty
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'images/no_all_shipments.png',
                                                width: 350,
                                                height: 330,
                                              ),
                                            ),
                                            Container(
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "There are not any shipments\n right now!",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    : buildShipmentsList(state)
                            : shimmerIsLoading
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => const ShimmerCard(),
                                      childCount: 2,
                                    ),
                                  )
                                : tripsIsEmpty || trips.isEmpty
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'images/no_trips.png',
                                                width: 350,
                                                height: 330,
                                              ),
                                            ),
                                            Container(
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "There are not any trips\n right now!",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    : !isTripPaginationLoading
                                        ? buildTripsList(
                                            state as GetAllTripsSuccessState)
                                        : buildTripsList(state
                                            as GetAllTripsPaginationLoadingState)
                      ],
                    ),
                  )
                  // ShipmentCard(
                  //   shipmentCardKey: shipmentCardKey,
                  // ),

                  // TripCard()
                ],
              ),
            ),
          );
        });
  }

  void showFromCountriesListBottomSheet(
      BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectFromCountry: () {},
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void getTrips() async {
    if (accessTokenProvider.accessToken != null) {
      await viewModel.getAlltrips(
        accessTokenProvider.accessToken!,
      );
    }

    // getChachedtrips().then((cachedTrips) {
    //   if (cachedTrips.isNotEmpty) {
    //     print('trips exist');
    //     setState(() {
    //       trips = cachedTrips;
    //     });
    //   } else {
    //     setState(() {
    //       viewModel.getAlltrips(token);
    //     });
    //   }
    // });
  }

  void showSuccessDialog(String successMsg) {
    _showShipmentDealConfirmedBottomSheet(context);
    // if (Platform.isIOS) {
    //   DialogUtils.showDialogIos(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // } else {
    //   DialogUtils.showDialogAndroid(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // }
  }

  Widget buildShipmentsList(Object? state) {
    AccessTokenProvider accessTokenProvider =
        Provider.of<AccessTokenProvider>(context);
    // String? accessToken = await storage.read(key: 'accessToken');

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: shipments.length + 1,
        (context, index) {
          if (index < shipments.length) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: HorizontalShipmentCard(
                shipmentDto: shipments[index],
                countriesStatesDto: args!.countriesFlagsDto.countries,
                showConfirmedBottomSheet: showSuccessDialog,
              ),
            );
          } else {
            if (totalShipmentsPage! >= currentShipmentsPage!) {
              if (accessTokenProvider.accessToken != null) {
                viewModel.getAllShipments(
                    token: accessTokenProvider.accessToken,
                    from: fromCountryIso,
                    to: toCountryIso,
                    isPagination: true);
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Platform.isIOS
                      ? const CupertinoActivityIndicator(
                          radius: 11,
                          color: Colors.black,
                        )
                      : const CircularProgressIndicator(),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Loading",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }

            // return Container();
          }
          return Container();
        },
      ),
    );
    // : state is GetAllShipsPaginationLoadingState
    //     ? SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //           childCount: shipments.length + 1,
    //           (context, index) {
    //             if (index < shipments.length) {
    //               print('trueeeeee');
    //               return ShipmentCard(
    //                 shipmentDto: shipments[index],
    //                 showConfirmedBottomSheet: showSuccessDialog,
    //               );
    //             } else {
    //               print('1st else');
    //               print(
    //                   'total $totalShipmentsPage current $currentShipmentsPage');
    //               if (totalShipmentsPage! >= currentShipmentsPage!) {
    //                 print('elseeeee');

    //                 return Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Platform.isIOS
    //                         ? const CupertinoActivityIndicator(
    //                             radius: 11,
    //                             color: Colors.black,
    //                           )
    //                         : const CircularProgressIndicator(),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     Text(
    //                       "Loading",
    //                       textAlign: TextAlign.center,
    //                       style: GoogleFonts.poppins(
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.grey[400]),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                   ],
    //                 );
    //               }

    //               // return Container();
    //             }
    //           },
    //         ),
    //       )
    //     : SliverToBoxAdapter(child: Container());
  }

  Widget buildTripsList(Object? state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: trips.length + 1,
        (context, index) {
          if (index < trips.length) {
            return TripCard(
              tripsDto: trips[index],
              // showConfirmedBottomSheet: showSuccessDialog,
            );
          } else {
            if (totalTripsPage! >= currentTripsPage!) {
              if (accessTokenProvider.accessToken != null) {
                viewModel.getAlltrips(accessTokenProvider.accessToken!,
                    isPagination: true);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Platform.isIOS
                        ? const CupertinoActivityIndicator(
                            radius: 11,
                            color: Colors.black,
                          )
                        : const CircularProgressIndicator(),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Loading",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
            }
          }
          return Container();
        },
      ),
    );
  }

  void _showShipmentDealConfirmedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => const DealConfirmedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void getShipments() async {
    if (accessTokenProvider.accessToken != null) {
      print('from init access token ${accessTokenProvider.accessToken}');
      print('from init refresh token ${accessTokenProvider.refreshToken}');

      await viewModel.getAllShipments(
        token: accessTokenProvider.accessToken!,
      );
    }

    // getCachedShipments().then((cachedShipments) {
    //   if (cachedShipments.isNotEmpty) {
    //     print('exist');
    //     setState(() {
    //       shipments = cachedShipments;
    //       shimmerIsLoading = false;
    //     });
    //   } else {
    //     viewModel.create(token); // Fetch from API if cache is empty
    //   }
    // });
  }
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

Image base64ToUserImage(String base64String) {
  Uint8List bytes = base64.decode(base64String);
  return Image.memory(
    bytes,
    fit: BoxFit.cover,
    width: 50,
    height: 50,
  );
}

/*   @override
  Widget build(BuildContext context) {
    const title = 'Floating App Bar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            const SliverAppBar(
              // Provide a standard title.
              title: Text(title),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
            ),
            // Next, create a SliverList
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
