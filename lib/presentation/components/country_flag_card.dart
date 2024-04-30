import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/country_dto.dart';

class CountryFlagCard extends StatelessWidget {
  String imageUrl = '';
  String? countryName = '', currencyName = '';
  CountriesStatesDto? countriesStatesDto;
  Function? selectFromCountry,
      selectToCountry,
      selectCurrency,
      selectCountry,
      selectCode;
  CountryFlagCard(
      {this.countryName,
      required this.imageUrl,
      this.currencyName,
      this.selectCountry,
      this.countriesStatesDto,
      this.selectCode,
      this.selectFromCountry,
      this.selectCurrency,
      this.selectToCountry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (selectFromCountry != null) {
            selectedFromCountry(selectFromCountry!);
          } else if (selectToCountry != null) {
            selectedToCountry(selectToCountry!);
          } else if (selectCurrency != null) {
            selectedCurrency(selectCurrency!);
          } else if (selectCountry != null) {
            selectedCountry(selectCountry!);
          } else if (selectCode != null) {
            selectedCode(selectCode!);
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
                  countryName!,
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

  void selectedCurrency(Function selectCurrency) {
    selectCurrency(countryName);
  }

  void selectedCode(Function selectCode) {
    selectCode(countriesStatesDto);
  }

  void selectedCountry(Function selectCountry) {
    selectCountry(countryName);
  }

  void selectedFromCountry(Function select) {
    select(countryName);
  }

  void selectedToCountry(Function select) {
    select(countryName);
  }
}
