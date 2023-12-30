import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripCard extends StatelessWidget {
  String? origin, destination, username;
  DateTime? date;
  int? availableWeight, consumedWeight;
  Image? userImage;

  TripCard(
      {required this.origin,
      required this.destination,
      required this.username,
      required this.availableWeight,
      required this.consumedWeight,
      required this.date,
      required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
                      'United states',
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
                        'Cairo',
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
                    'Departs on 22 December 2023',
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
                        '9Kg Available',
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
                        '0Kg Consumed',
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
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alaa Hosni',
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
                    onPressed: () {},
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
    );
  }
}
