import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/trip_deal/deals.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/login/login_screen.dart';

import '../home/tabs/trips/create_trip_screen.dart';

class MyTripCardForDeals extends StatelessWidget {
  String? origin, destination, username;
  String? date;
  int? availableWeight;
  int? consumedWeight;
  Image? userImage;
  Deal deal;
  Function showSuccessDialog;

  MyTripCardForDeals(
      {required this.origin,
      required this.destination,
      required this.deal,
      required this.showSuccessDialog,
      this.username,
      required this.availableWeight,
      required this.consumedWeight,
      required this.date,
      this.userImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          print('user trip : ${deal.tripsDto.origin}');

          _showTripDealConfirmationBottomSheet(
              context, deal, showSuccessDialog);
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        origin!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.flight_land_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          destination ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Departs At $date',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/bag.png',
                          width: 20,
                          height: 50,
                          filterQuality: FilterQuality.high,
                        ),
                        Text(
                          '${availableWeight.toString()} Available Kg',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/bag.png',
                          width: 20,
                          height: 50,
                          filterQuality: FilterQuality.high,
                        ),
                        Text(
                          '${consumedWeight.toString()} Consumed Kg',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/package.png',
                          width: 20,
                          height: 50,
                          filterQuality: FilterQuality.high,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '0 Deals',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${'\$0.00 Earnings'}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTripDealConfirmationBottomSheet(
      BuildContext context, Deal deal, Function showSuccessDialog) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TripDealConfirmationBottomSheet(
        deal: deal,
        showSuccessDialog: showSuccessDialog,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Image base64ToUserImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    );
  }
}
