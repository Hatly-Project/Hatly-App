import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryFlagCard extends StatelessWidget {
  String imageUrl = '';
  String countryName = '';
  Function? selectFromCountry, selectToCountry;
  CountryFlagCard(
      {required this.countryName,
      required this.imageUrl,
      this.selectFromCountry,
      this.selectToCountry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (selectFromCountry == null) {
            selectedToCountry(selectToCountry!);
          } else {
            selectedFromCountry(selectFromCountry!);
          }
        },
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .1,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * .50,
                child: Text(
                  countryName,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectedFromCountry(Function select) {
    select(countryName);
  }

  void selectedToCountry(Function select) {
    select(countryName);
  }
}
