import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_text_field.dart';

class ShipmentItemBottomSheet extends StatefulWidget {
  Function addItem;
  Function onError;
  String? itemName, itemWeight, itemPrice, itemLink;
  bool? update;
  int? itemId;

  ShipmentItemBottomSheet(
      {required this.addItem,
      required this.onError,
      this.itemName,
      this.itemPrice,
      this.itemWeight,
      this.itemLink,
      required this.update,
      this.itemId});

  @override
  State<ShipmentItemBottomSheet> createState() =>
      _ShipmentItemBottomSheetState();
}

class _ShipmentItemBottomSheetState extends State<ShipmentItemBottomSheet> {
  var fromCountryValue = '';
  String? fromStateValue;
  String? base64Image;
  var toCountryValue = '';
  List<PhotoDto> itemPhotos = [];

  String? toStateValue;
  double _bottomSheetPadding = 20.0;
  var nameController = TextEditingController(text: '');
  var weightController = TextEditingController(text: '');

  var linkController = TextEditingController(text: '');

  var priceController = TextEditingController(text: '');
  List<XFile>? image;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.itemName);
    weightController = TextEditingController(text: widget.itemWeight);

    linkController = TextEditingController(text: widget.itemLink);

    priceController = TextEditingController(text: widget.itemPrice);
    print('init ${widget.itemName}');
  }

  @override
  Widget build(BuildContext context) {
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
                    'Add shipment Item',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                CustomFormField(
                  controller: nameController,
                  label: '',
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
                  label: '',
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
                  label: '',
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
                  label: '',
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
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(color: Colors.white)),
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
                        add(widget.addItem, context, widget.onError,
                            widget.itemId,
                            update: widget.update);
                      },
                      child: Text(
                        'Add Item',
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                // TextField(
                //   controller: nameController,
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

  void add(
      Function addItem, BuildContext context, Function onError, int? itemId,
      {bool? update = false}) async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    } else if (image == null) {
      onError(context, 'Please add item picture');
      return;
    }
    print(update);
    addItem(nameController.text, priceController.text, linkController.text,
        itemPhotos, weightController.text, update, widget.itemId);
    Navigator.of(context).pop();
    // viewModel.login(emailController.text, passwordController.text);
  }

  void pickPhoto(Function onError) async {
    final ImagePicker picker = ImagePicker();

    // Pick an image.
    image = await picker.pickMultiImage(maxWidth: 100, maxHeight: 100);

    if (image != null) {
      // Read the image file as bytes.
      for (var element in image!) {
        List<int> im = await element.readAsBytes();
        base64Image = base64Encode(im);
        itemPhotos.add(PhotoDto(photo: base64Image));
      }
      // List<int> imageBytes = await image!.readAsBytes();

      // // Convert the image bytes to a Base64 encoded string.
      // base64Image = base64Encode(imageBytes);

      // itemPhotos.add(PhotoDto(photo: base64Image));
      // // Now you have the image as a Base64 string.
      // print('Base64 encoded image: $base64Image');
      for (var element in itemPhotos) {
        print('base ${element.photo}');
      }
      setState(() {});
    } else {
      if (kDebugMode) {
        print('no');
      }
    }
  }
}
