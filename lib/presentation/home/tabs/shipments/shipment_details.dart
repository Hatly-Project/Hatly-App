import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/components/shopping_items_card.dart';
import 'package:hatly/presentation/home/bottom_nav_icon.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/trips_list_bottom_sheet.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';

class ShipmentDetails extends StatefulWidget {
  String? shipmentTitle;
  static const routeName = 'ShipmentDetails';

  ShipmentDetails({this.shipmentTitle});

  @override
  State<ShipmentDetails> createState() => _ShipmentDetailsState();
}

class _ShipmentDetailsState extends State<ShipmentDetails> {
  ScrollController scrollController = ScrollController();

  var selectedIndex = 0;

  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ShipmentDetailsArguments;
    ShipmentDto shipmentDto = args.shipmentDto;
    int shoppingItems = shipmentDto.items!.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        // iconSize: 10,
        enableFeedback: true,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: selectedIndex,
        elevation: 0,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('home', selectedIndex == 0),
              label: 'Home'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('fast', selectedIndex == 1),
              label: 'My Shipments'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('airplane', selectedIndex == 2),
              label: 'My Trips'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: BottomNavIcon('profile', selectedIndex == 3),
              label: ''),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          shipmentDto.title!,
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
        // physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {},
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    // width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width * .3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      shipmentDto.from!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      shipmentDto.fromCity!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Image.asset(
                              'images/black-plane-2.png',
                              width: 30,
                              height: 30,
                            )),
                            Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width * .3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      shipmentDto.to!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      shipmentDto.toCity!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.date_range_rounded,
                                size: 20,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  '  Expected by ',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  DateFormat('dd MMMM yyyy')
                                      .format(shipmentDto.expectedDate!),
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            '',
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$shoppingItems shopping item(s)',
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => ShoppingItemsCard(
                      itemDto: shipmentDto.items![index],
                    ),
                childCount: shoppingItems),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reward',
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '\$USD ${shipmentDto.reward}',
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.sizeOf(context).width * .45,
                                  MediaQuery.sizeOf(context).height * .07),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () {
                            _showTripsListBottomSheet(
                                context, showSuccessDialog, shipmentDto);
                            // login();
                          },
                          child: Text(
                            'Send offer',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showSuccessDialog(String successMsg) {
    _showShipmentDealConfirmedBottomSheet(context);
    // if (Platform.isIOS) {
    //   DialogUtils.showDialogIos(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // } else {
    //   DialogUtils.showDialogAndroid(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // }
  }

  void _showShipmentDealConfirmedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => DealConfirmedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void _showTripsListBottomSheet(BuildContext context,
      Function showSuccessDialog, ShipmentDto shipmentDto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TripsListBottomSheet(
        showSuccessDialog: showSuccessDialog,
        shipmentDto: shipmentDto,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
}
