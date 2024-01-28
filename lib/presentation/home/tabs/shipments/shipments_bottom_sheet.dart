import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/presentation/components/shipment_item.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_fees_bottom.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_item_bottom.dart';
import 'package:hatly/presentation/home/tabs/trips/countries_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/states_list_bottom_sheet.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_text_field.dart';

class AddShipmentBottomSheet extends StatefulWidget {
  Function onError;
  Function done;
  CountriesDto countriesDto;

  AddShipmentBottomSheet(
      {required this.onError, required this.done, required this.countriesDto});

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
  String fromStateValue = "", date = '';
  String fromCityValue = "",
      toCityValue = "",
      toStateValue = "",
      fromCountry = "",
      toCountry = "";
  List<StateDto> fromStatesList = [];
  List<StateDto> toStatesList = [];

  double _bottomSheetPadding = 20.0;
  List<ItemDto> items = [];
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();

  var dateController = TextEditingController(text: '');
  var nameController = TextEditingController(text: '');
  var noteController = TextEditingController(text: '');
  var weightController = TextEditingController(text: '');
  var bonusController = TextEditingController(text: '');
  late CountriesDto countries;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    countries = widget.countriesDto;
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(160, 45),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              backgroundColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () {
                            showFromCountriesListBottomSheet(
                                context, countries);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .42,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.amber,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'From',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  width: MediaQuery.sizeOf(context).width * .2,
                                  child: Text(
                                    fromCountry.isEmpty
                                        ? 'Country'
                                        : fromCountry,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: fromCountry.isNotEmpty
                            ? () {
                                showFromStatesListBottomSheet(
                                    context, fromStatesList);
                              }
                            : null,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * .4,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.amber,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  'From',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                width: MediaQuery.sizeOf(context).width * .17,
                                child: Text(
                                  fromCityValue.isEmpty
                                      ? 'City'
                                      : fromCityValue,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'To',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(160, 45),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              backgroundColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () {
                            showToCountriesListBottomSheet(context, countries);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .42,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.amber,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'To',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  width: MediaQuery.sizeOf(context).width * .2,
                                  child: Text(
                                    toCountry.isEmpty ? 'Country' : toCountry,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              backgroundColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.amber,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'To',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  width: MediaQuery.sizeOf(context).width * .2,
                                  child: Text(
                                    toCityValue.isEmpty ? 'City' : toCityValue,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
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
                      shipImage:
                          base64ToImage(items[index].photos!.first.photo!),
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
    done(fromCountry, fromCityValue, toCityValue, toCountry, date,
        nameController.text, noteController.text, bonus, items);
  }

  void confirm() {
    // totalWeight = weight;
    // bonus = bonus;
    // fees = fees;

    done(widget.done, bonus);
  }

  void addItem(String title, String price, String link, List<PhotoDto> images,
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
            photos: images,
            id: id)
        : items.add(ItemDto(
            name: itemItile,
            price: double.tryParse(itemPrice),
            link: link,
            weight: double.tryParse(weight),
            photos: images,
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
            (fromCountry.isEmpty || fromCityValue.isEmpty) ||
        (toCountry.isEmpty || toCityValue.isEmpty)) {
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
