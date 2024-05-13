import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_details.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_deal_details.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trip_deal_details_argument.dart';
import 'package:hatly/presentation/home/tabs/shipments/trips_list_bottom_sheet.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class MyTripDealCard extends StatefulWidget {
  TripsDto tripsDto;
  TripDealDto dealDto;
  bool? isFromTripDealDetails;
  // Function showConfirmedBottomSheet;
  MyTripDealCard(
      {required this.tripsDto,
      this.isFromTripDealDetails = false,
      // required this.showConfirmedBottomSheet,
      required this.dealDto});

  @override
  State<MyTripDealCard> createState() => _MyTripDealCardState();
}

class _MyTripDealCardState extends State<MyTripDealCard> {
  late LoggedInState loggedInState;
  late String userEmail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      userEmail = loggedInState.user.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
      child: InkWell(
        onTap: () {
          widget.isFromTripDealDetails!
              ? null
              : Navigator.pushNamed(context, MyTripDealDetails.routeName,
                  arguments: MyTripDealDetailsArgument(
                      deal: widget.dealDto, tripsDto: widget.tripsDto));
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
                  if (widget.dealDto.creatorEmail != userEmail)
                    Container(
                      // margin: EdgeInsets.only(top: 5),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .045,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.amber),
                      child: Center(
                        child: Text(
                          'An offer from shopper ${widget.dealDto.shopper?.firstName}',
                          // textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.dealDto.shipment?.items?.first.photos == null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                  )
                                : Image.network(
                                    widget.dealDto.shipment!.items!.first
                                        .photos!.first.photo!,
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
                                      widget.dealDto.shipment!.title!,
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
                                  width: MediaQuery.sizeOf(context).width * .62,
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            widget.dealDto.shipment!.from!,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.flight_land_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            widget.dealDto.shipment!.to!,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
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
                                        widget.dealDto.shipment!.expectedDate!),
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
                                        child: widget.dealDto.shopper!
                                                    .profilePhoto !=
                                                null
                                            ? base64ToUserImage(widget
                                                .dealDto.shopper!.profilePhoto!)
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
                                        widget.dealDto.shopper!.firstName!,
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
                                width: MediaQuery.sizeOf(context).width * .25,
                                height: MediaQuery.sizeOf(context).height * .04,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: widget.dealDto.dealStatus
                                                ?.toLowerCase() ==
                                            'pending'
                                        ? Colors.amber
                                        : widget.dealDto.dealStatus
                                                    ?.toLowerCase() ==
                                                'accepted'
                                            ? Colors.green
                                            : widget.dealDto.dealStatus
                                                        ?.toLowerCase() ==
                                                    'rejected'
                                                ? Colors.red
                                                : null),
                                child: Center(
                                  child: Text(
                                    widget.dealDto.dealStatus!.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                        'Shipping Bonus ${widget.dealDto.finalReward} \$',
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
