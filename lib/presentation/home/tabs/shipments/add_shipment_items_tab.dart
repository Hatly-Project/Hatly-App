import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddShipmentItemsTab extends StatefulWidget {
  const AddShipmentItemsTab({super.key});

  @override
  State<AddShipmentItemsTab> createState() => _AddShipmentItemsTabState();
}

class _AddShipmentItemsTabState extends State<AddShipmentItemsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  late List<ItemDto> items;
  String? dropDownValue;
  TextEditingController itemNameController = TextEditingController(text: '');
  TextEditingController itemLinkController = TextEditingController(text: '');
  TextEditingController itemPriceController = TextEditingController(text: '');
  TextEditingController itemWeightController = TextEditingController(text: '');

  int quantityCounter = 0;
  List<XFile>? image;
  List<PhotoDto> itemPhotos = [];
  String? base64Image;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: ExpansionTile(
            title: Text(
              'Item 1',
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.transparent,
            initiallyExpanded: true,
            // trailing: Icon(Icons.arrow_forward_ios),
            // subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomFormField(
                  controller: itemNameController,
                  label: null,
                  hint: 'Item Name',
                  // onChange: (p0) => checkIsButtonEnabled(),

                  keyboardType: TextInputType.name,
                  // validator: (text) {
                  //   if (text == null || text.trim().isEmpty) {
                  //     return 'please enter shipment name';
                  //   }
                  //   // if (!ValidationUtils.isValidEmail(text)) {
                  //   //   return 'please enter a valid email';
                  //   // }
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomFormField(
                  controller: itemLinkController,
                  label: null,
                  hint: 'Item Link',
                  // onChange: (p0) => checkIsButtonEnabled(),

                  keyboardType: TextInputType.name,
                  // validator: (text) {
                  //   if (text == null || text.trim().isEmpty) {
                  //     return 'please enter shipment name';
                  //   }
                  //   // if (!ValidationUtils.isValidEmail(text)) {
                  //   //   return 'please enter a valid email';
                  //   // }
                  // },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomFormField(
                        controller: itemPriceController,
                        label: null,
                        hint: 'Item Price',
                        // onChange: (p0) => checkIsButtonEnabled(),

                        keyboardType: TextInputType.name,
                        // validator: (text) {
                        //   if (text == null || text.trim().isEmpty) {
                        //     return 'please enter shipment name';
                        //   }
                        //   // if (!ValidationUtils.isValidEmail(text)) {
                        //   //   return 'please enter a valid email';
                        //   // }
                        // },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomFormField(
                        controller: itemWeightController,
                        label: null,
                        hint: 'Item Weight',
                        // onChange: (p0) => checkIsButtonEnabled(),

                        keyboardType: TextInputType.name,
                        // validator: (text) {
                        //   if (text == null || text.trim().isEmpty) {
                        //     return 'please enter shipment name';
                        //   }
                        //   // if (!ValidationUtils.isValidEmail(text)) {
                        //   //   return 'please enter a valid email';
                        //   // }
                        // },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                  width: double.infinity,
                  height: 60,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropDownValue,
                      hint: Text('Categories'),
                      // icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(fontSize: 15),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.white,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                          // dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Electronics',
                        'Clothing & Apparel',
                        'Home & Kitchen',
                        'Beauty & Personal Care',
                        'Toys & Games',
                        'Health & Wellness',
                        'Automotive',
                        'Jewelry & Watches',
                        'Pet Supplies',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Qunatity',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantityCounter > 0
                                  ? quantityCounter--
                                  : quantityCounter = 0;
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF393939),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.minimize_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            quantityCounter.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                quantityCounter++;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF393939),
                              child: Align(
                                // alignment: Alignment.topCenter,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Item Photos',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => pickPhoto(),
                      child: Image.asset(
                        'images/camera_frame.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    itemPhotos.isNotEmpty
                        ? Container(
                            height: 110,
                            width: MediaQuery.sizeOf(context).width * .58,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(10),
                              itemCount: itemPhotos.length,
                              itemBuilder: (context, index) =>
                                  base64ToImage(itemPhotos[index].photo!),
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Image base64ToImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.scaleDown,
      width: 100,
      height: 100,
    );
  }

  void pickPhoto() async {
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
