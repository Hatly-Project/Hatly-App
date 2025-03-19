import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class ShipmentItemCard extends StatefulWidget {
  String? title;
  Function addItem;
  ShipmentItemCard({super.key, this.title, required this.addItem});

  @override
  State<ShipmentItemCard> createState() => _ShipmentItemCardState();
}

class _ShipmentItemCardState extends State<ShipmentItemCard> {
  late List<ItemDto> items;
  bool _isButtonEnabled = false;
  String? dropDownValue;
  TextEditingController itemNameController = TextEditingController(text: '');
  TextEditingController itemLinkController = TextEditingController(text: '');
  TextEditingController itemPriceController = TextEditingController(text: '');
  TextEditingController itemWeightController = TextEditingController(text: '');

  int quantityCounter = 0;
  List<XFile>? image;
  List<PhotoDto> itemPhotos = [];
  String? base64Image;
  bool isCollapsed = true;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          widget.title!,
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        initiallyExpanded: false,
        onExpansionChanged: (value) {
          setState(() {
            isCollapsed = value;
          });
        },
        // trailing: Icon(Icons.arrow_forward_ios),
        // subtitle: Text('Trailing expansion arrow icon'),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomFormField(
              controller: itemNameController,
              label: null,
              hint: 'Item Name',
              onChange: (p0) => checkIsButtonEnabled(),

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
              onChange: (p0) => checkIsButtonEnabled(),

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
                    onChange: (p0) => checkIsButtonEnabled(),

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
                    onChange: (p0) => checkIsButtonEnabled(),

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
                        checkIsButtonEnabled();
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
                          checkIsButtonEnabled();
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
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 80,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
              border: Border.all(color: Colors.white),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(
                        color: _isButtonEnabled
                            ? const Color(0xFF4141DA)
                            : Colors.grey),
                  ),
                ),
              ),
              onPressed: _isButtonEnabled
                  ? () {
                      widget.addItem(
                        itemNameController.text.trim(),
                        itemPriceController.text.trim(),
                        itemLinkController.text.trim(),
                        // itemPhotos,
                        itemWeightController.text.trim(),
                        quantityCounter.toString(),
                      );
                    }
                  : null,
              child: Text(
                'Add Item',
                style: TextStyle(
                    color: _isButtonEnabled
                        ? const Color(0xFF4141DA)
                        : Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  void checkIsButtonEnabled() {
    if (itemNameController.text.trim().isNotEmpty &&
        itemLinkController.text.trim().isNotEmpty &&
        itemPriceController.text.trim().isNotEmpty &&
        itemWeightController.text.trim().isNotEmpty &&
        quantityCounter > 0) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
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
