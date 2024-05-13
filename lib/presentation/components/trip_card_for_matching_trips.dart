import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details_arguments.dart';
import 'package:intl/intl.dart';

class MatchingTripCard extends StatefulWidget {
  TripsDto tripsDto;
  Deal? deal;

  MatchingTripCard({required this.tripsDto, this.deal});

  @override
  State<MatchingTripCard> createState() => _TripCardState();
}

class _TripCardState extends State<MatchingTripCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, TripDetails.routeName,
            arguments: TripDetailsArguments(tripsDto: widget.tripsDto)),
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
                        widget.tripsDto.origin!,
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
                          widget.tripsDto.destination ?? '',
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
                      'Departs At ${DateFormat('dd MMMM yyyy').format(widget.tripsDto.departDate!)}',
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
                          width: 15,
                          height: 50,
                          filterQuality: FilterQuality.high,
                        ),
                        Text(
                          '${widget.tripsDto.available.toString()} Available Kg',
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
                          width: 15,
                          height: 50,
                          filterQuality: FilterQuality.high,
                        ),
                        Text(
                          '${widget.tripsDto.consumed.toString()} Consumed Kg',
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
                Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: widget.tripsDto.user!.profilePhoto == null
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.grey[300],
                                  )
                                : base64ToUserImage(
                                    widget.tripsDto.user!.profilePhoto!)),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tripsDto.user!.firstName!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Text(
                              '4.3 Reviews',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        _showShipmentDealConfirmationBottomSheet(
                            context, showSuccessDialog);
                      },
                      child: Text(
                        'Send Request',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
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

  void _showShipmentDealConfirmationBottomSheet(
      BuildContext context, Function showSuccessDialog) {
    // Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ShipmentDealConfirmationBottomSheet(
          deal: widget.deal!, showSuccessDialog: showSuccessDialog),
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
