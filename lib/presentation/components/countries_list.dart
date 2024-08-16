import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/presentation/components/country_flag_card.dart';

class CountriesList extends StatefulWidget {
  CountriesDto countries;
  Function? selectCurrency, selectCountry, selectCode;
  Function? selectFromCountry, selectToCountry;
  Function? hideOverLay;
  CountriesList(
      {required this.countries,
      this.selectFromCountry,
      this.selectCode,
      this.hideOverLay,
      this.selectCountry,
      this.selectToCountry,
      this.selectCurrency});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  ScrollController scrollController = ScrollController();
  List<CountriesStatesDto> filteredCountries = [];
  @override
  void initState() {
    super.initState();
    filteredCountries.addAll(widget.countries.countries!);
  }

  void filterList(String query) {
    filteredCountries.clear();
    if (query.isNotEmpty) {
      if (widget.selectCurrency != null) {
        widget.countries.countries?.forEach((country) {
          if (country.currency!.toLowerCase().startsWith(query.toLowerCase())) {
            filteredCountries.add(country);
          }
        });
      } else if (widget.selectFromCountry != null ||
          widget.selectToCountry != null) {
        widget.countries.countries?.forEach((country) {
          if (country.name!.toLowerCase().startsWith(query.toLowerCase())) {
            filteredCountries.add(country);
          }
        });
      } else if (widget.selectCountry != null) {
        widget.countries.countries?.forEach((country) {
          if (country.iso2!.toLowerCase().startsWith(query.toLowerCase())) {
            filteredCountries.add(country);
          }
        });
      } else if (widget.selectCode != null) {
        widget.countries.countries?.forEach((country) {
          if (country.name!.toLowerCase().startsWith(query.toLowerCase())) {
            filteredCountries.add(country);
          }
        });
      }
    } else {
      filteredCountries.addAll(widget.countries.countries!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Material(
          elevation: 4.0,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterList(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    labelText: 'Search',
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 5, bottom: 5),
                    child: Container(
                      // margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                  controller: scrollController,
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) => CountryFlagCard(
                    countryName: widget.selectFromCountry != null ||
                            widget.selectToCountry != null
                        ? filteredCountries[index].name!
                        : widget.selectCurrency != null
                            ? filteredCountries[index].currency!
                            : widget.selectCode != null
                                ? filteredCountries[index].name!
                                : filteredCountries[index].iso2!,
                    countriesStatesDto: filteredCountries[index],
                    imageUrl: filteredCountries[index].flag!,
                    selectFromCountry: widget.selectFromCountry,
                    selectCountry: widget.selectCountry,
                    selectCode: widget.selectCode,
                    selectCurrency: widget.selectCurrency,
                    selectToCountry: widget.selectToCountry,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
