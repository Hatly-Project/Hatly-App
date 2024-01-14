import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryFlagCard extends StatelessWidget {
  String imageUrl = '';
  String countryName = '';
  CountryFlagCard({required this.countryName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              countryName,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
