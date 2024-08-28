import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:intl/intl.dart';

class ShipmentDetailsCard extends StatelessWidget {
  String? fromCountryFlag, fromCountryName, toCountryFlag, toCountryName;
  ShipmentDto? shipmentDto;
  ShipmentDetailsCard({
    this.fromCountryFlag,
    this.fromCountryName,
    this.toCountryFlag,
    this.toCountryName,
    this.shipmentDto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: Theme.of(context).textTheme.displayMedium,
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          fromCountryFlag!,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 90,
                            child: Text(
                              fromCountryName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 17),
                              textScaler: TextScaler.noScaling,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            shipmentDto!.fromCity!,
                            style: Theme.of(context).textTheme.displayMedium,
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
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
                  Text(
                    'To',
                    style: Theme.of(context).textTheme.displayMedium,
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          toCountryFlag!,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // width: 70,
                            child: Text(
                              toCountryName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 17),
                              textScaler: TextScaler.noScaling,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            shipmentDto!.toCity!,
                            style: Theme.of(context).textTheme.displayMedium,
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
              // thickness: 2,
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Before Date: ',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 15),
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    formatDate(shipmentDto!.expectedDate!),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 17),
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: 50,
                  child: VerticalDivider(
                    color: Color(0xFFEEEEEE),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meet: ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 15),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Person',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 15),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  child: VerticalDivider(
                    color: Color(0xFFEEEEEE),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight: ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 15),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      shipmentDto!.wight.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 17),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    // Define the desired format
    DateFormat formatter = DateFormat('d MMM, yyyy');

    // Format the DateTime object
    return formatter.format(dateTime);
  }
}
