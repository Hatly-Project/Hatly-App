import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/ui/components/custom_text_field.dart';
import 'package:hatly/ui/home/tabs/trips/my_trips_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';

class CreateTripScreen extends StatefulWidget {
  static const String routeName = 'CreateTrip';

  CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  MyTripsViewmodel viewModel = MyTripsViewmodel();
  final MultiSelectController _controller = MultiSelectController();

  List<TripsDto> myTrips = [];
  List<ItemsNotAllowedDto> itemsNotAllowed = [];
  String countryValue = "";
  String? selecteditem = '';
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
  Image? shipImage;
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
    return BlocConsumer(
      bloc: viewModel,
      listener: (context, state) {
        if (state is CreateTripLoadingState) {
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
          DialogUtils.hideDialog(context);
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
          // cacheMytrips(myTrips);
          // cacheMyShipments(myTrips);
        }
        return Scaffold(
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          CSCPicker(
                            ///Enable disable state dropdown [OPTIONAL PARAMETER]
                            showStates: true,

                            /// Enable disable city drop down [OPTIONAL PARAMETER]
                            showCities: false,

                            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                            flagState: CountryFlag.DISABLE,

                            ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                            dropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),

                            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.shade300,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),

                            ///placeholders for dropdown search field
                            countrySearchPlaceholder: "Country",
                            stateSearchPlaceholder: "State",
                            citySearchPlaceholder: "City",

                            ///labels for dropdown
                            countryDropdownLabel: "*Country",
                            stateDropdownLabel: "*State",
                            cityDropdownLabel: "*City",

                            ///Default Country
                            //defaultCountry: CscCountry.India,

                            ///Disable country dropdown (Note: use it with default country)
                            //disableCountry: true,

                            ///selected item style [OPTIONAL PARAMETER]
                            selectedItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                            dropdownHeadingStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),

                            ///DropdownDialog Item style [OPTIONAL PARAMETER]
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///Dialog box radius [OPTIONAL PARAMETER]
                            dropdownDialogRadius: 10.0,

                            ///Search bar radius [OPTIONAL PARAMETER]
                            searchBarRadius: 10.0,

                            ///triggers once country selected in dropdown
                            onCountryChanged: (value) {
                              setState(() {
                                ///store value in country variable
                                fromCountry = value;
                              });
                            },

                            ///triggers once state selected in dropdown
                            onStateChanged: (value) {
                              setState(() {
                                ///store value in state variable
                                fromStateValue = value ?? "";
                              });
                            },

                            ///triggers once city selected in dropdown

                            onCityChanged: (value) {
                              setState(() {
                                fromCityValue = value ?? "";
                              });
                            },
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          CSCPicker(
                            ///Enable disable state dropdown [OPTIONAL PARAMETER]
                            showStates: true,

                            /// Enable disable city drop down [OPTIONAL PARAMETER]
                            showCities: false,

                            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                            flagState: CountryFlag.DISABLE,

                            ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                            dropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),

                            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.shade300,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),

                            ///placeholders for dropdown search field
                            countrySearchPlaceholder: "Country",
                            stateSearchPlaceholder: "State",
                            citySearchPlaceholder: "City",

                            ///labels for dropdown
                            countryDropdownLabel: "*Country",
                            stateDropdownLabel: "*State",
                            cityDropdownLabel: "*City",

                            ///Default Country
                            //defaultCountry: CscCountry.India,

                            ///Disable country dropdown (Note: use it with default country)
                            //disableCountry: true,

                            ///selected item style [OPTIONAL PARAMETER]
                            selectedItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                            dropdownHeadingStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),

                            ///DropdownDialog Item style [OPTIONAL PARAMETER]
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///Dialog box radius [OPTIONAL PARAMETER]
                            dropdownDialogRadius: 10.0,

                            ///Search bar radius [OPTIONAL PARAMETER]
                            searchBarRadius: 10.0,

                            ///triggers once country selected in dropdown
                            onCountryChanged: (value) {
                              setState(() {
                                ///store value in country variable
                                toCountry = value;
                              });
                            },

                            ///triggers once state selected in dropdown
                            onStateChanged: (value) {
                              setState(() {
                                ///store value in state variable
                                toStateValue = value ?? "";
                              });
                            },

                            onCityChanged: (value) {
                              setState(() {
                                toCityValue = value ?? "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 2,
                      thickness: 3,
                      color: Colors.grey[500],
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
                    Center(
                      child: Text(
                        'Categories do not like to carry',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Center(
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
                        chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                        dropdownHeight: 500,
                        optionTextStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CustomFormField(
                        controller: noteController,
                        hint: 'Note',
                        lines: 5,
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
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          print('note ${noteController.text}');
                          create(
                              origin: fromCountry,
                              destination: toCountry,
                              dateTime: date,
                              available:
                                  int.tryParse(availableWeightController.text),
                              airline: airlineController.text,
                              bookReference: bookingReferenceController.text,
                              firstName: firstNameController.text,
                              note: noteController.text.isEmpty
                                  ? null
                                  : noteController.text,
                              lastName: lastNameController.text,
                              itemsNotAllowed: itemsNotAllowed);
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
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
            (fromCountry.isEmpty || fromStateValue.isEmpty) ||
        (toCountry.isEmpty || toStateValue.isEmpty)) {
      onError(context, 'Please choose a country');
      return;
    }

    viewModel.createTrip(
      token: token,
      origin: origin,
      destination: destination,
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
          departDateController.text = selectedDate.toIso8601String();
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
