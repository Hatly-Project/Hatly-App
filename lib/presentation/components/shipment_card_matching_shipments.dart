import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_details.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips_details_screen.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/trips_list_bottom_sheet.dart';
import 'package:intl/intl.dart';

class MatchingShipmentCard extends StatefulWidget {
  ShipmentDto shipmentDto;
  Deal? deal;
  MatchingShipmentCard({required this.shipmentDto, required this.deal});

  @override
  State<MatchingShipmentCard> createState() => _MatchingShipmentCardState();
}

class _MatchingShipmentCardState extends State<MatchingShipmentCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('deal trip ${widget.deal!.tripsDto.destination}');
  }

  @override
  Widget build(BuildContext context) {
    Deal deal = widget.deal!;
    return Container(
      padding: EdgeInsets.all(6),
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ShipmentDetails.routeName,
              arguments:
                  ShipmentDetailsArguments(shipmentDto: widget.shipmentDto));
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * .95,
              // height: MediaQuery.of(context).size.height * .29,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.shipmentDto.items?.first.photos == null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                  )
                                : Image.network(
                                    widget.shipmentDto.items!.first.photos!
                                        .first.photo!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      widget.shipmentDto.title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * .6,
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              widget.shipmentDto.from!,
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.flight_land_rounded,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            widget.shipmentDto.to!,
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    DateFormat('dd MMMM yyyy').format(
                                        widget.shipmentDto.expectedDate!),
                                    style: GoogleFonts.poppins(
                                        fontSize: 10, color: Colors.grey[600]),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: double.infinity,
                          height: 2,
                          color: Colors.grey[400],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: widget.shipmentDto.user!
                                                    .profilePhoto !=
                                                null
                                            ? base64ToUserImage(widget
                                                .shipmentDto
                                                .user!
                                                .profilePhoto!)
                                            : Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey[300],
                                              )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        widget.shipmentDto.user!.firstName!,
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Text('4.3 Reviews')
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child: ElevatedButton(
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
                                    print('tripp ${deal.tripsDto.destination}');
                                    _showTripDealConfirmationBottomSheet(
                                      showSuccessDialog,
                                      deal,
                                    );
                                  },
                                  child: Text(
                                    'Send offer',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .045,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        'Shipping Bonus ${widget.shipmentDto.reward} \$',
                        // textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )),
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

  void _showTripDealConfirmationBottomSheet(
      Function showSuccessDialog, Deal deal) {
    // Navigator.pop(context);
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

  Image base64ToImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.fitHeight,
      width: 100,
      height: 100,
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
