import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/components/shipment_item_card.dart';
import 'package:image_picker/image_picker.dart';

class AddShipmentItemsTab extends StatefulWidget {
  const AddShipmentItemsTab({super.key});

  @override
  State<AddShipmentItemsTab> createState() => _AddShipmentItemsTabState();
}

class _AddShipmentItemsTabState extends State<AddShipmentItemsTab> {
  List<Widget> itemsList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemsList = [
      ShipmentItemCard(
        title: "Item 1",
        addItem: addItem,
      ),
    ];
  }

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
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: itemsList,
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
                    side: const BorderSide(color: Color(0xFF4141DA)),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  itemsList.add(ShipmentItemCard(
                    addItem: addItem,
                    title: "Item ${itemsList.length + 1}",
                  ));
                });
              },
              child: const Text(
                'Add New Item',
                style: TextStyle(color: Color(0xFF4141DA)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void addItem(String? title, String? price, String? link, String? weight,
      String? quantity) {
    print("title $title");
    print("price $price");
    print("link $link");
    // print("images $images");
    print("weight $weight");
    print("quantity $quantity");
  }
}
