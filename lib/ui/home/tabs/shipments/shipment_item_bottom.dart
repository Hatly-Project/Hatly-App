import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_text_field.dart';

class ShipmentItemBottomSheet extends StatefulWidget {
  Function addItem;
  ShipmentItemBottomSheet({required this.addItem});

  @override
  State<ShipmentItemBottomSheet> createState() =>
      _ShipmentItemBottomSheetState();
}

class _ShipmentItemBottomSheetState extends State<ShipmentItemBottomSheet> {
  var fromCountryValue = '';
  String? fromStateValue;
  var toCountryValue = '';
  String? toStateValue;
  double _bottomSheetPadding = 20.0;
  var dateController = TextEditingController(text: '');
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
                  controller: priceController,
                  label: 'Email Address',
                  hint: 'Item price',
                  keyboardType: TextInputType.text,
                  validator: (name) {
                    if (name == null || name.trim().isEmpty) {
                      return 'please enter shipment name';
                    }
                  },
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
                        add(widget.addItem);
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

  void add(Function addItem) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    }
    addItem(dateController.text, priceController.text);
    // viewModel.login(emailController.text, passwordController.text);
  }
}
