import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmation_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_deal_confirmation_bottom_sheet.dart';

class MyShipmentCard extends StatelessWidget {
  String title;
  String from;
  String to;
  String date;
  Image? shipImage;
  bool isDealTap;
  Deal? deal;
  ShipmentDto shipmentDto;
  Function? showSuccessDialog;
  MyShipmentCard(
      {required this.title,
      required this.from,
      required this.shipmentDto,
      this.showSuccessDialog,
      required this.to,
      required this.date,
      this.deal,
      this.isDealTap = false,
      this.shipImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
      child: InkWell(
        onTap: () {
          if (isDealTap) {
            _showShipmentDealConfirmationBottomSheet(
                context, deal!, showSuccessDialog!);
          } else {
            Navigator.pushNamed(context, MyShipmentDetails.routeName,
                arguments:
                    MyShipmentDetailsArguments(shipmentDto: shipmentDto));
          }
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shipImage ?? Container(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  title,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width:
                                      MediaQuery.sizeOf(context).width * .238,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      from,
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.flight_land_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * .245,
                                  margin: EdgeInsets.only(left: 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      to,
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                'Before $date',
                                style: GoogleFonts.poppins(
                                    fontSize: 10, color: Colors.grey[600]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 10),
                    //   width: double.infinity,
                    //   height: 2,
                    //   color: Colors.grey[400],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Container(
                    //           margin: EdgeInsets.only(top: 10),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(25),
                    //             child: Image.asset(
                    //               'images/me.jpg',
                    //               width: 50,
                    //               height: 50,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Text(
                    //               'Alaa',
                    //               style: GoogleFonts.poppins(
                    //                   fontSize: 13,
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             SizedBox(
                    //               height:
                    //                   MediaQuery.of(context).size.height * .02,
                    //             ),
                    //             Text('4.3 Reviews')
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //     Container(
                    //       child: ElevatedButton(
                    //         style: ButtonStyle(
                    //           shape: MaterialStatePropertyAll(
                    //             RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //           ),
                    //           backgroundColor: MaterialStatePropertyAll(
                    //               Theme.of(context).primaryColor),
                    //         ),
                    //         onPressed: () {},
                    //         child: Text('Send Request'),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5),
                    //   width: double.infinity,
                    //   height: MediaQuery.of(context).size.height * .045,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Theme.of(context).primaryColor),
                    //   child: Center(
                    //     child: Text(
                    //       'Shipping Bonus 50.5 \$',
                    //       // textAlign: TextAlign.start,
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _showShipmentDealConfirmationBottomSheet(
      BuildContext context, Deal deal, Function showSuccessDialog) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ShipmentDealConfirmationBottomSheet(
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
}
