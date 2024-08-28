import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_list_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details_arguments.dart';
import 'package:intl/intl.dart';

class HorizontalTripCard extends StatefulWidget {
  TripsDto? tripsDto;
  Deal? deal;
  List<CountriesStatesDto>? countriesStatesDto;

  HorizontalTripCard({this.tripsDto, this.deal, this.countriesStatesDto});

  @override
  State<HorizontalTripCard> createState() => _TripCardState();
}

class _TripCardState extends State<HorizontalTripCard> {
  late String fromCountryFlag, toCountryFlag, fromCountryName, toCountryName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromCountryFlag = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.tripsDto!.origin)]
        .flag!;

    fromCountryName = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.tripsDto!.origin)]
        .name!;

    toCountryFlag = widget
        .countriesStatesDto![widget.countriesStatesDto!.indexWhere(
            (country) => country.iso2 == widget.tripsDto!.destination)]
        .flag!;
    toCountryName = widget
        .countriesStatesDto![widget.countriesStatesDto!.indexWhere(
            (country) => country.iso2 == widget.tripsDto!.destination)]
        .name!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TripDetails.routeName,
            arguments: TripDetailsArguments(
              tripsDto: widget.tripsDto!,
              countriesStatesDto: widget.countriesStatesDto,
            ),
          );
        },
        child: Container(
          // height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFEEEEEE),
            ),
            color: const Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'images/me.jpg',
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        width: 77,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${widget.tripsDto!.user!.firstName} ${widget.tripsDto!.user!.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    // margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/date_icon.png',
                              width: 14,
                              height: 14,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              width: 75,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Departs On: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              width: 140,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  formatISO8601Date(widget.tripsDto!.departDate!
                                      .toIso8601String()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 13),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/weight_icob.png',
                                width: 14,
                                height: 14,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                width: 100,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Available Weight: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            // fontSize: 5,
                                            fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                width: 27,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    '${widget.tripsDto!.available}kg',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                            // fontSize: 5,
                                            fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    // margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'From:',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        // fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    fromCountryFlag,
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SizedBox(
                                    width: 75,
                                    child: Text(
                                      fromCountryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'images/landing_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 18,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'To:',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        // fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    toCountryFlag,
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: SizedBox(
                                    width: 50,
                                    child: Text(
                                      toCountryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatISO8601Date(String isoDate) {
    // Parse the ISO 8601 date string to DateTime
    DateTime dateTime = DateTime.parse(isoDate);

    // Define the desired format
    DateFormat formatter = DateFormat('EEE, dd MMM - hh:mm a');

    // Format the DateTime object
    return formatter.format(dateTime);
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

  void _showShipmentsListBottomSheet(
      BuildContext context, TripsDto trip, Function showSuccessDialog) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ShipmentsListBottomSheet(
        tripsDto: trip,
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

  void _showTripDealConfirmationBottomSheet(
      BuildContext context, Function showSuccessDialog) {
    Navigator.pop(context);
    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.grey[100],
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   builder: (context) => TripDealConfirmationBottomSheet(
    //     deal: widget.deal!,
    //     showSuccessDialog: showSuccessDialog,
    //   ),
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(20),
    //       topRight: Radius.circular(20),
    //     ),
    //   ),
    // );
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
