import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutingNumberBottomSheet extends StatelessWidget {
  const RoutingNumberBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.info),
                Container(
                  width: MediaQuery.sizeOf(context).width * .87,
                  child: Text(
                    'A SWIFT/BIC code consists of 8-11 characters and follows a format that identifies your bank, country, location, and branch.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'images/routingg.png',
          ),
        ],
      ),
    );
  }
}
