import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_text_field.dart';

class ShipmentItemBottomSheet extends StatefulWidget {
  Function addItem;
  Function onError;

  ShipmentItemBottomSheet({required this.addItem, required this.onError});

  @override
  State<ShipmentItemBottomSheet> createState() =>
      _ShipmentItemBottomSheetState();
}

class _ShipmentItemBottomSheetState extends State<ShipmentItemBottomSheet> {
  var fromCountryValue = '';
  String? fromStateValue;
  String? base64Image;
  var toCountryValue = '';
  String? toStateValue;
  double _bottomSheetPadding = 20.0;
  var dateController = TextEditingController(text: '');
  var weightController = TextEditingController(text: '');

  var linkController = TextEditingController(text: '');

  var priceController = TextEditingController(text: '');
  XFile? image;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedPadding(
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
                      'Add shipment Item',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  CustomFormField(
                    controller: dateController,
                    label: 'Email Address',
                    hint: 'Item title',
                    keyboardType: TextInputType.text,
                    // readOnly: true,
                    // icon: Icon(Icons.local_shipping_rounded),
                    validator: (date) {
                      if (date == null || date.trim().isEmpty) {
                        return 'please enter the title';
                      }
                    },
                  ),
                  CustomFormField(
                    controller: linkController,
                    label: 'Email Address',
                    hint: 'Item link',
                    keyboardType: TextInputType.text,
                    // readOnly: true,
                    // icon: Icon(Icons.local_shipping_rounded),
                    validator: (date) {
                      if (date == null || date.trim().isEmpty) {
                        return 'please enter the link';
                      }
                    },
                  ),
                  CustomFormField(
                    controller: priceController,
                    label: 'Email Address',
                    hint: 'Item price',
                    keyboardType: TextInputType.text,
                    validator: (name) {
                      if (name == null || name.trim().isEmpty) {
                        return 'please enter item price';
                      }
                    },
                  ),
                  CustomFormField(
                    controller: weightController,
                    label: 'Email Address',
                    hint: 'Item weight',
                    keyboardType: TextInputType.text,
                    validator: (name) {
                      if (name == null || name.trim().isEmpty) {
                        return 'please enter item weight';
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 25),
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
                          pickPhoto(widget.onError);
                        },
                        child: Text(
                          'Pick Photo',
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 25),
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
                          add(widget.addItem, context, widget.onError);
                        },
                        child: Text(
                          'Add Item',
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
      ),
    );
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

  void add(Function addItem, BuildContext context, Function onError) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    } else if (image == null) {
      onError(context, 'Please add item picture');
      return;
    }

    addItem(dateController.text, priceController.text, linkController.text,
        base64Image, weightController.text);
    Navigator.of(context).pop();
    // viewModel.login(emailController.text, passwordController.text);
  }

  void pickPhoto(Function onError) async {
    final ImagePicker picker = ImagePicker();

    // Pick an image.
    image = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 100, maxHeight: 100);

    if (image != null) {
      // Read the image file as bytes.
      List<int> imageBytes = await image!.readAsBytes();

      // Convert the image bytes to a Base64 encoded string.
      base64Image = base64Encode(imageBytes);

      // Now you have the image as a Base64 string.
      print('Base64 encoded image: $base64Image');
      setState(() {});
    } else {
      onError(context);
    }
  }
}
