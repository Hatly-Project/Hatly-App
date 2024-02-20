import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';

class MyShipmentCardForDeals extends StatelessWidget {
  String title;
  String from;
  String to;
  String date;
  Image? shipImage;
  bool isDealTap;
  Deal? deal;

  MyShipmentCardForDeals(
      {required this.title,
      required this.from,
      required this.to,
      required this.date,
      this.deal,
      this.isDealTap = false,
      this.shipImage});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * .95,
          // height: MediaQuery.of(context).size.height * .29,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                shipImage ?? Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      width: MediaQuery.sizeOf(context).width * .41,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * .2,
                              child: Text(
                                from,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Icon(
                                Icons.flight_land_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * .15,
                              child: Text(
                                to,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey[600]),
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
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        'Before $date',
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  // void _showTripDealConfirmationBottomSheet(BuildContext context, Deal deal) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.grey[100],
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     builder: (context) => TripDealConfirmationBottomSheet(
  //       deal: deal,
  //     ),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //   );
  // }
}
