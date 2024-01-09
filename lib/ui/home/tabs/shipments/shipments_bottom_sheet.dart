import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/ui/components/shipment_item.dart';
import 'package:hatly/ui/home/tabs/shipments/shipment_fees_bottom.dart';
import 'package:hatly/ui/home/tabs/shipments/shipment_item_bottom.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_text_field.dart';

class AddShipmentBottomSheet extends StatefulWidget {
  Function onError;
  Function done;

  AddShipmentBottomSheet({required this.onError, required this.done});

  @override
  State<AddShipmentBottomSheet> createState() => _AddShipmentBottomSheetState();
}

class _AddShipmentBottomSheetState extends State<AddShipmentBottomSheet> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  int itemID = 0;

  String itemItile = '';
  String itemPrice = '';
  String totalItems = '1';
  double totalWeight = 0;
  String bonus = '';
  String fees = '';
  String image = '';
  bool isDoneBtnShown = false;
  Image? shipmentImage;

  int index = 0;

  String toCountryValue = '';
  String toStateValue = '';
  double _bottomSheetPadding = 20.0;
  List<ItemDto> items = [];
  String date = '';
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();

  var dateController = TextEditingController(text: '');
  var nameController = TextEditingController(text: '');
  var noteController = TextEditingController(text: '');
  var weightController = TextEditingController(text: '');
  var bonusController = TextEditingController(text: '');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add shipment',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Text(
                  'From',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

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
                      countryValue = value;
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      stateValue = value ?? "";
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value ?? "";
                    });
                  },
                ),
                // CountryStateCityPicker(
                //     country: country,
                //     state: state,
                //     city: city,
                //     dialogColor: Colors.grey.shade200,
                //     textFieldDecoration: InputDecoration(
                //         fillColor: Colors.blueGrey.shade100,
                //         filled: true,
                //         suffixIcon: const Icon(Icons.arrow_downward_rounded),
                //         border: const OutlineInputBorder(
                //             borderSide: BorderSide.none))),
                Text(
                  'To',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

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
                      toCountryValue = value;
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      toStateValue = value ?? "";
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value ?? "";
                    });
                  },
                ),
                CustomFormField(
                  controller: dateController,
                  label: '',
                  hint: 'I want it before',
                  readOnly: true,
                  icon: Icon(Icons.local_shipping_rounded),
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
                CustomFormField(
                  controller: nameController,
                  label: '',
                  hint: 'Shipment Name',
                  keyboardType: TextInputType.text,
                  validator: (name) {
                    if (name == null || name.trim().isEmpty) {
                      return 'please enter shipment name';
                    }
                  },
                ),
                CustomFormField(
                  controller: noteController,
                  label: '',
                  hint: 'Shipment Note',
                  keyboardType: TextInputType.text,
                  validator: (note) {
                    if (note == null || note.trim().isEmpty) {
                      return 'please enter shipment note';
                    }
                  },
                ),
                // CustomFormField(
                //   controller: weightController,
                //   label: 'Email Address',
                //   hint: 'Shipment Weight',
                //   keyboardType: TextInputType.text,
                //   validator: (note) {
                //     if (note == null || note.trim().isEmpty) {
                //       return 'please enter shipment weight';
                //     }
                //   },
                // ),
                // CustomFormField(
                //   controller: bonusController,
                //   label: 'Email Address',
                //   hint: 'Shipping Bonus',
                //   keyboardType: TextInputType.number,
                //   validator: (note) {
                //     if (note == null || note.trim().isEmpty) {
                //       return 'please enter shipping bonus';
                //     }
                //   },
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ShipmentItem(
                      itemTitle: items[index].name!,
                      itemPrice: items[index].price.toString(),
                      itemLink: items[index].link!,
                      weight: items[index].weight.toString(),
                      shipImage: base64ToImage(items[index].photo!),
                      id: items[index].id,
                      update: update,
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.of(context).size.width * .6, 50)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        add(
                          widget.onError,
                        );
                      },
                      child: Text(
                        'Add shipment item',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                isDoneBtnShown
                    ? Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(Size(
                                  MediaQuery.of(context).size.width * .6, 50)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              showShipmentFeesBottomSheet(context);
                            },
                            child: Text(
                              'Done',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Container()
                // TextField(
                //   controller: dateController,
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     hintText: 'I want it before',
                //     icon: Icon(Icons.local_shipping),
                //   ),
                //   onTap: () {
                //     DateTime selectedDate = DateTime.now();
                //     _selectDate(context);
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
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
                  dateController.text =
                      '${formattedDate + ' ' + formattedTime}';

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
          dateController.text = selectedDate.toIso8601String();
        });
      }
    }
  }

  void showDoneBtn() {
    setState(() {
      isDoneBtnShown = true;
    });
  }

  void done(Function done, String bonus) {
    done(countryValue, stateValue, toStateValue, toCountryValue, date,
        nameController.text, noteController.text, bonus, items);
  }

  void confirm() {
    // totalWeight = weight;
    // bonus = bonus;
    // fees = fees;

    done(widget.done, bonus);
  }

  void addItem(String title, String price, String link, String baseImage,
      String weight, bool update, int? id) {
    itemItile = title;
    itemPrice = price;
    totalWeight = 0;

    print('id is $id');
    update
        ? items[items.indexWhere((item) => item.id == id)] = ItemDto(
            name: itemItile,
            price: double.tryParse(itemPrice),
            link: link,
            weight: double.tryParse(weight),
            photo: baseImage,
            id: id)
        : items.add(ItemDto(
            name: itemItile,
            price: double.tryParse(itemPrice),
            link: link,
            weight: double.tryParse(weight),
            photo: baseImage,
            id: itemID++));
    print('shipment weight $weight');
    totalItems = items.length.toString();
    bonus = '200';
    fees = '90';
    for (var item in items) {
      print(item.name);
      totalWeight += item.weight!;
      print('tot $totalWeight');
    }
    setState(() {
      showDoneBtn();
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

  void showShipmentItemBottomSheet(
      {required BuildContext context,
      String? itemName,
      String? itemPrice,
      String? itemLink,
      String? itemWeight,
      bool update = false,
      int? id}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) => ShipmentItemBottomSheet(
        addItem: addItem,
        onError: widget.onError,
        itemName: itemName,
        itemLink: itemLink,
        itemId: id,
        itemPrice: itemPrice,
        itemWeight: itemWeight,
        update: update,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                'Please choose country',
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

  void showShipmentFeesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) => ShipmentFeesBottomSheet(
        confrim: confirm,
        totalItems: totalItems,
        totalWeight: totalWeight.toString(),
        bonus: bonus,
        fees: fees,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void add(Function onError) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    } else if (formKey.currentState?.validate() == true &&
            (countryValue.isEmpty || stateValue.isEmpty) ||
        (toCountryValue.isEmpty || toStateValue.isEmpty)) {
      onError(context, 'Please choose a country');
      return;
    }
    showShipmentItemBottomSheet(context: context);
    // viewModel.login(emailController.text, passwordController.text);
  }

  void update(String? itemName, String? itemWeight, String? itemPrice,
      String? itemLink, bool? update, int? id) {
    showShipmentItemBottomSheet(
        context: context,
        itemName: itemName,
        itemLink: itemLink,
        itemPrice: itemPrice,
        itemWeight: itemWeight,
        update: update!,
        id: id);
  }
}
