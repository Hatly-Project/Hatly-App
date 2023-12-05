import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_text_field.dart';

class ShipmentFeesBottomSheet extends StatefulWidget {
  Function confrim;
  String? totalItems;
  String? totalWeight;
  String? bonus;
  String? fees;
  Function? onError;

  ShipmentFeesBottomSheet(
      {required this.confrim,
      this.totalItems,
      this.totalWeight,
      this.bonus,
      this.onError,
      this.fees});

  @override
  State<ShipmentFeesBottomSheet> createState() =>
      _ShipmentFeesBottomSheetState();
}

class _ShipmentFeesBottomSheetState extends State<ShipmentFeesBottomSheet> {
  var fromCountryValue = '';
  String? fromStateValue;
  String? base64Image;
  var toCountryValue = '';
  String? toStateValue;
  double _bottomSheetPadding = 20.0;
  var dateController = TextEditingController(text: '');
  var linkController = TextEditingController(text: '');

  var priceController = TextEditingController(text: '');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom + _bottomSheetPadding),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: SingleChildScrollView(
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
                    'Confirm shipment',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total items',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          widget.totalItems!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total weight',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          '${widget.totalWeight} g',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Traveler bonus',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          '${widget.bonus} \$',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hatly fees',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          '${widget.fees} \$',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.of(context).size.width * .5, 50)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        confirm(widget.confrim);
                      },
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

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

  void confirm(Function confirm) {
    confirm();
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    if (Platform.isIOS) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  final formattedDate = DateFormat('yyyy-MM-dd')
                      .format(selectedDate); // Format the date
                  dateController.text = formattedDate;
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
          final formattedDate =
              DateFormat('yyyy-MM-dd').format(selectedDate); // Format the date
          dateController.text = formattedDate;
        });
      }
    }
  }

  void add(Function addItem) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    }
    addItem(dateController.text, priceController.text, linkController.text,
        base64Image);
    // viewModel.login(emailController.text, passwordController.text);
  }

  void pickPhoto() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Read the image file as bytes.
      List<int> imageBytes = await image.readAsBytes();

      // Convert the image bytes to a Base64 encoded string.
      base64Image = base64Encode(imageBytes);

      // Now you have the image as a Base64 string.
      print('Base64 encoded image: $base64Image');
      setState(() {});
    }
  }
}
