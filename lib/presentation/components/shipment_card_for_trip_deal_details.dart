import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/trip_deal_dto.dart';
import 'package:hatly/presentation/components/my_shipment_card.dart';
import 'package:intl/intl.dart';

class ShipmentCardForTripDealDetails extends StatelessWidget {
  TripDealDto dealDto;
  Color? cardBAckgroundColor, cardText;
  ShipmentCardForTripDealDetails(
      {required this.dealDto,
      this.cardBAckgroundColor = const Color.fromRGBO(47, 40, 77, 30),
      this.cardText = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cardBAckgroundColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: dealDto.shopper!.profilePhoto != null
                              ? Image.network(
                                  dealDto.shopper!.profilePhoto,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[500],
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dealDto.shopper!.firstName!,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: cardText),
                            ),
                            Text(
                              '${dealDto.shopper!.averageRating.toString()} Reviews',
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: cardText),
                            ),
                            // Text(
                            //   '${substractDates(dealDto.shopper!.!)} days ago',
                            //   overflow: TextOverflow.fade,
                            //   style: GoogleFonts.poppins(
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.bold,
                            //       color: cardText),
                            // ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyShipmentCard(
                      title: dealDto.shipment!.title!,
                      from: dealDto.shipment!.from!,
                      shipmentDto: dealDto.shipment!,
                      to: dealDto.shipment!.to!,
                      date: DateFormat('dd-MMM-yyyy')
                          .format(dealDto.shipment!.expectedDate!),
                      shipImage: Image.network(
                        dealDto.shipment!.items!.first.photos!.first.photo!,
                        fit: BoxFit.fitWidth,
                        width: 100,
                        height: 100,
                      ), //
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color.fromARGB(255, 140, 128, 153),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .13,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Notes:  ',
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  dealDto.shipment?.notes ?? 'No Notes',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color.fromARGB(255, 140, 128, 153),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Meeting Points:  ',
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * .35,
                              //   child: Text(
                              //     dealDto.shipment?.addressMeeting ?? 'Any',
                              //     overflow: TextOverflow.fade,
                              //     style: GoogleFonts.poppins(
                              //         fontSize: 13,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
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
    );
  }

  String substractDates(DateTime dateTime) {
    DateTime dateNow = DateTime.now();

    var substractedDate = dateNow.difference(dateTime);

    var daysAgo = substractedDate.inDays;

    return daysAgo.toString();
  }
}
