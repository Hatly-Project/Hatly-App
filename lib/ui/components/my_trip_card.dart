import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTripCard extends StatelessWidget {
  String? origin, destination, username;
  String? date;
  int? availableWeight, consumedWeight;
  Image? userImage;

  MyTripCard(
      {required this.origin,
      required this.destination,
      this.username,
      required this.availableWeight,
      required this.consumedWeight,
      required this.date,
      this.userImage});

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
                      origin!,
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
                        destination ?? '',
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
                    'Departs At $date',
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
                        '${availableWeight.toString()} Available Kg',
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
                        '${consumedWeight.toString()} Consumed Kg',
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
            ],
          ),
        ),
      ),
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
