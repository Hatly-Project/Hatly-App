import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_details.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/trips_list_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HorizontalShipmentCard extends StatefulWidget {
  ShipmentDto? shipmentDto;
  Function? showConfirmedBottomSheet;
  final GlobalKey? shipmentCardKey;
  List<CountriesStatesDto>? countriesStatesDto;
  HorizontalShipmentCard(
      {this.shipmentDto,
      this.showConfirmedBottomSheet,
      this.countriesStatesDto,
      this.shipmentCardKey});

  @override
  State<HorizontalShipmentCard> createState() => _HorizontalShipmentCardState();
}

class _HorizontalShipmentCardState extends State<HorizontalShipmentCard> {
  late String fromCountryFlag, toCountryFlag, fromCountryName, toCountryName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromCountryFlag = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.shipmentDto!.from)]
        .flag!;

    fromCountryName = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.shipmentDto!.from)]
        .name!;

    toCountryFlag = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.shipmentDto!.to)]
        .flag!;
    toCountryName = widget
        .countriesStatesDto![widget.countriesStatesDto!
            .indexWhere((country) => country.iso2 == widget.shipmentDto!.to)]
        .name!;
  }

  @override
  Widget build(BuildContext context) {
    // print('imgg ${shipmentDto.items!.first.photos!.first.photo}');
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Container(
        // height: 100,
        // width: 320,
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
                          "${widget.shipmentDto!.user!.firstName!} ${widget.shipmentDto!.user!.lastName!}",
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.shipmentDto!.items!.first.photos!.first.photo!,
                      fit: BoxFit.fitHeight,
                      width: 50,
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 270,
                            // height: 15,
                            child: Text(
                              widget.shipmentDto!.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            // margin: EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/weight_icob.png',
                                  width: 14,
                                  height: 14,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  width: 27,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${widget.shipmentDto!.wight}g',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 1.5,
                                  color: Color(0xFFD6D6D6),
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                ),
                                Image.asset(
                                  'images/date_icon.png',
                                  width: 14,
                                  height: 14,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  width: 110,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Before: ${formatDate(widget.shipmentDto!.expectedDate!.toIso8601String())}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
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
                          ),
                        ],
                      ),
                    ),
                  ],
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
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 95,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'Shipment From:',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 12,
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
                                  width: 100,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      fromCountryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                      width: 22,
                      height: 22,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Receiving In:',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 12,
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
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: SizedBox(
                                  width: 45,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      toCountryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      // margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 1.5,
                            color: Color(0xFFD6D6D6),
                            margin: EdgeInsets.only(right: 10),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: SizedBox(
                                  width: 50,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Reward',
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
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    width: 33,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        widget.shipmentDto!.reward.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'USD',
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
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
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

  Image base64ToUserImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    );
  }

  String formatDate(String initDate) {
    DateTime date = DateTime.parse(initDate);
    DateFormat formatter = DateFormat("dd MMM");
    String formattedDate = formatter.format(date);
    return formattedDate;
    print(formattedDate); // Output: 30 Aug
  }
}
