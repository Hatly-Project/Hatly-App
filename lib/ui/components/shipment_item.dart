import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/ui/home/tabs/shipments/shipment_item_bottom.dart';

class ShipmentItem extends StatelessWidget {
  String itemTitle;
  String itemPrice;
  String itemLink;
  String weight;
  Image? shipImage;
  Function? update;
  int? id;
  ShipmentItem(
      {required this.itemTitle,
      required this.itemPrice,
      this.shipImage,
      required this.itemLink,
      this.id,
      this.update,
      required this.weight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
      child: InkWell(
        onTap: () {
          update!(itemTitle, weight, itemPrice, itemLink, true, id);
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
                              child: Text(
                                itemTitle,
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    weight + ' Kg',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.grey[600]),
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
                                '${'\$' + itemPrice}',
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey[600]),
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
                    // Expanded(
                    //   child: Container(
                    //     margin: EdgeInsets.only(top: 5),
                    //     width: double.infinity,
                    //     height: MediaQuery.of(context).size.height * .045,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Theme.of(context).primaryColor),
                    //     child: Center(
                    //       child: Text(
                    //         'Shipping Bonus 50.5 \$',
                    //         // textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold),
                    //       ),
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
}
