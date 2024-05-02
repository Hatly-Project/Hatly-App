import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/components/countries_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/create_trip_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/trips/states_list_bottom_sheet.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';

class CreateTripScreen extends StatefulWidget {
  static const String routeName = 'CreateTrip';

  CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  late MyTripsViewmodel viewModel;
  late AccessTokenProvider accessTokenProvider;
  final MultiSelectController _controller = MultiSelectController();

  List<TripsDto> myTrips = [];
  List<ItemsNotAllowedDto> itemsNotAllowed = [];
  String countryValue = "";
  String? selecteditem = '';
  bool isLoading = false;
  String fromStateValue = "", date = '';
  String fromCityValue = "",
      toCityValue = "",
      toStateValue = "",
      fromCountry = "",
      toCountry = "";
  var departDateController = TextEditingController(text: '');

  var availableWeightController = TextEditingController(text: '');

  var airlineController = TextEditingController(text: '');

  var noteController = TextEditingController(text: '');

  var bookingReferenceController = TextEditingController(text: '');

  var firstNameController = TextEditingController(text: '');

  var lastNameController = TextEditingController(text: '');

  var formKey = GlobalKey<FormState>();
  late String token;
  ScrollController scrollController = ScrollController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  bool isMyTripsEmpty = true;
  int selectedCountryIndex = 0;
  late CountriesDto countries;
  Image? shipImage;
  List<StateDto> fromStatesList = [];
  List<StateDto> toStatesList = [];

  late LoggedInState loggedInState;

  @override
  void initState() {
    super.initState();

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = MyTripsViewmodel(accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }

    // Check for cached shipments when initializing
    // Future.delayed(Duration(milliseconds: 300), () {
    //   getCachedMyShipments().then((cachedShipments) {
    //     if (cachedShipments.isNotEmpty) {
    //       print('exist');
    //       setState(() {
    //         myTrips = cachedShipments;
    //       });
    //     } else {
    //       viewModel.getMyShipments(token: token);
    //       print('no Exist'); // Fetch from API if cache is empty
    //     }
    //   });
    // });
  }

  // a method for caching the shipments list
  Future<void> cacheMytrips(List<TripsDto> trips) async {
    final box = await Hive.openBox(
        'trips${loggedInState.user.email!.replaceAll('@', '_at_')}');

    // Convert List<ShipmentDto> to List<Map<String, dynamic>>
    final tripsMaps = trips.map((trip) => trip.toJson()).toList();

    // Clear existing data and store the new data in the box
    print('done caching');
    await box.clear();
    await box.addAll(tripsMaps);
  }

  Future<List<TripsDto>> getCachedMyShipments() async {
    final box = await Hive.openBox(
        'trips${loggedInState.user.email!.replaceAll('@', '_at_')}');
    final tripsMaps = box.values.toList();

    // Convert List<Map<String, dynamic>> to List<ShipmentDto>
    final trips = tripsMaps.map((trip) => TripsDto.fromJson(trip)).toList();

    return trips;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as CreatetripScreenArguments;
    countries = args.countriesFlagsDto;

    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is CreateTripLoadingState) {
          isLoading = true;
        } else if (state is CreateTripFailState) {
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
        if (previous is CreateTripLoadingState) {
          isLoading = false;
        }
        if (current is CreateTripLoadingState ||
            current is CreateTripFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CreateTripSuccessState) {
          print('getSuccess');
          TripsDto? trip = state.responseDto.trip;
          myTrips.add(trip!);
          isMyTripsEmpty = false;
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          // cacheMytrips(myTrips);
          // cacheMyShipments(myTrips);
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                iconTheme: IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  'Create Trip',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Trip route',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(160, 45),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () {
                                            showFromCountriesListBottomSheet(
                                                context, countries);
                                          },
                                          child: Container(
                                            width: 150,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'From',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  width: 65,
                                                  child: Text(
                                                    fromCountry.isEmpty
                                                        ? 'Country'
                                                        : fromCountry,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(160, 45),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: () {
                                            showToCountriesListBottomSheet(
                                                context, countries);
                                          },
                                          child: Container(
                                            width: 150,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'To',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  width: 70,
                                                  child: Text(
                                                    toCountry.isEmpty
                                                        ? 'Country'
                                                        : toCountry,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(160, 45),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: fromCountry.isNotEmpty
                                              ? () {
                                                  showFromStatesListBottomSheet(
                                                      context, fromStatesList);
                                                }
                                              : null,
                                          child: Container(
                                            width: 150,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'From',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  width: 60,
                                                  child: Text(
                                                    fromCityValue.isEmpty
                                                        ? 'City'
                                                        : fromCityValue,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(160, 45),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12)),
                                          onPressed: toCountry.isNotEmpty
                                              ? () {
                                                  showToStatesListBottomSheet(
                                                      context, toStatesList);
                                                }
                                              : null,
                                          child: Container(
                                            width: 150,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'To',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  width: 60,
                                                  child: Text(
                                                    toCityValue.isEmpty
                                                        ? 'City'
                                                        : toCityValue,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            'Trip details',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              CustomFormField(
                                controller: departDateController,
                                // label: '',
                                hint: 'Depart date and time',
                                readOnly: true,
                                icon: Icon(Icons.date_range_rounded),
                                validator: (date) {
                                  if (date == null || date.trim().isEmpty) {
                                    return 'please choose date';
                                  }
                                },
                                onTap: () {
                                  DateTime selectedDate = DateTime.now();
                                  _selectDate(context);
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: CustomFormField(
                                  controller: availableWeightController,
                                  keyboardType: TextInputType.number,
                                  hint: 'Available weight in KG',
                                  icon: Icon(Icons.monitor_weight_rounded),
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'please enter the available weight';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            'Ticket info',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              CustomFormField(
                                controller: airlineController,
                                // label: '',
                                hint: 'Airline',
                                icon: Icon(Icons.flight),
                                validator: (date) {
                                  if (date == null || date.trim().isEmpty) {
                                    return 'please enter the airline name';
                                  }
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: CustomFormField(
                                  controller: bookingReferenceController,
                                  keyboardType: TextInputType.number,
                                  hint: 'Booking reference',
                                  icon: Icon(Icons.airplane_ticket_rounded),
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'please enter your booking reference';
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: CustomFormField(
                                  controller: firstNameController,
                                  hint: 'First name on the ticket',
                                  icon: Icon(Icons.airplane_ticket_rounded),
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'please enter your first name on the ticket';
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: CustomFormField(
                                  controller: lastNameController,
                                  hint: 'Last name on the ticket',
                                  icon: Icon(Icons.airplane_ticket_rounded),
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'please enter your last name on the ticket';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              'Categories do not like to carry',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: MultiSelectDropDown(
                              showClearIcon: true,
                              controller: _controller,
                              onOptionSelected: (items) {
                                itemsNotAllowed = items
                                    .map((item) =>
                                        ItemsNotAllowedDto(name: item.label))
                                    .toList();

                                for (var element in itemsNotAllowed) {
                                  print(element.name);
                                }
                              },
                              options: const <ValueItem>[
                                ValueItem(label: 'Mobiles & Tablets'),
                                ValueItem(label: 'Laptops'),
                                ValueItem(label: 'Cosmetics'),
                                ValueItem(label: 'Clothing'),
                                ValueItem(label: 'Shoes & Bags'),
                                ValueItem(label: 'Watches & Sunglasses'),
                                ValueItem(label: 'Supplements'),
                                ValueItem(label: 'Food & Beverages'),
                                ValueItem(label: 'Books'),
                              ],
                              selectionType: SelectionType.multi,
                              chipConfig:
                                  const ChipConfig(wrapType: WrapType.scroll),
                              dropdownHeight: 500,
                              optionTextStyle: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                              selectedOptionIcon:
                                  const Icon(Icons.check_circle),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: CustomFormField(
                            controller: noteController,
                            hint: 'Note',
                            lines: 3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 60),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                side: BorderSide(color: Colors.white, width: 2),
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                            onPressed: () {
                              print('note ${noteController.text}');
                              create(
                                  origin: fromCountry,
                                  destination: toCountry,
                                  dateTime: date,
                                  available: int.tryParse(
                                      availableWeightController.text),
                                  airline: airlineController.text,
                                  bookReference:
                                      bookingReferenceController.text,
                                  firstName: firstNameController.text,
                                  note: noteController.text.isEmpty
                                      ? null
                                      : noteController.text,
                                  lastName: lastNameController.text,
                                  itemsNotAllowed: itemsNotAllowed);
                            },
                            child: const Text(
                              'Create',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void showFromCountriesListBottomSheet(
      BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectFromCountry: selectFromCountry,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showToCountriesListBottomSheet(
      BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectToCountry: selectToCountry,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showFromStatesListBottomSheet(
      BuildContext context, List<StateDto> states) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => StatesListBottomSheet(
        states: states,
        selectFromCity: selectFromCity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showToStatesListBottomSheet(
      BuildContext context, List<StateDto> states) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => StatesListBottomSheet(
        states: states,
        selectToCity: selectToCity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void selectFromCountry(String selectedCountry) {
    Navigator.pop(context);
    var index = countries.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = countries.countries![index!].states;

    setState(() {
      fromCountry = selectedCountry;
      fromCityValue = '';
      fromStatesList = countryStates!;
    });
  }

  void selectToCountry(String selectedCountry) {
    Navigator.pop(context);
    var index = countries.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = countries.countries![index!].states;

    setState(() {
      toCountry = selectedCountry;
      toCityValue = '';
      toStatesList = countryStates!;
    });
  }

  void selectFromCity(String selectedCity) {
    Navigator.pop(context);

    setState(() {
      fromCityValue = selectedCity;
    });
  }

  void selectToCity(String selectedCity) {
    Navigator.pop(context);

    setState(() {
      toCityValue = selectedCity;
    });
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

  void create(
      {required String? origin,
      required String? destination,
      required String? dateTime,
      required int? available,
      required String? airline,
      required String? bookReference,
      required String? firstName,
      required String? lastName,
      String? note,
      required List<ItemsNotAllowedDto>? itemsNotAllowed}) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    } else if (formKey.currentState?.validate() == true &&
            (fromCountry.isEmpty || fromCityValue.isEmpty) ||
        (toCountry.isEmpty || toCityValue.isEmpty)) {
      onError(context, 'Please choose a country');
      return;
    }

    viewModel.createTrip(
      token: accessTokenProvider.accessToken!,
      origin: origin,
      destination: destination,
      originCity: fromCityValue,
      destinationCity: toCityValue,
      departDate: dateTime,
      available: available,
      note: note,
      addressMeeting: 'Mahtet El raml',
      bookInfoDto: BookInfoDto(
          firstName: firstName,
          lastName: lastName,
          bookingReference: bookReference,
          airline: airline),
      itemsNotAllowed: itemsNotAllowed,
    );
    // viewModel.login(emailController.text, passwordController.text);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    if (Platform.isIOS) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  final formattedDate = DateFormat('dd MMMM yyyy')
                      .format(selectedDate); // Format the date
                  final time = TimeOfDay.fromDateTime(selectedDate);
                  // Format the date
                  var formattedTime = time.format(context);
                  departDateController.text =
                      '${formattedDate + ' at ' + formattedTime}';

                  date = selectedDate.toIso8601String();

                  //                   final formattedDate = TimeOfDay.fromDateTime(selectedDate);
                  // // Format the date
                  // dateController.text = formattedDate.format(context);
                });
              },
            ),
          );
        },
      );
    } else if (Platform.isAndroid) {
      var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          final formattedDate = DateFormat('dd MMMM yyyy')
              .format(selectedDate); // Format the date
          final time = TimeOfDay.fromDateTime(selectedDate);
          // Format the date
          var formattedTime = time.format(context);
          departDateController.text =
              '${formattedDate + ' at ' + formattedTime}';

          date = selectedDate.toIso8601String();
        });
      }
    }
  }

  void onError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
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
}
