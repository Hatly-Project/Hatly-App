import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/ui/components/country_flag_card.dart';

class CountriesListBottomSheet extends StatefulWidget {
  CountriesDto countries;
  Function? selectFromCountry, selectToCountry;
  CountriesListBottomSheet(
      {required this.countries, this.selectFromCountry, this.selectToCountry});

  @override
  State<CountriesListBottomSheet> createState() =>
      _CountriesListBottomSheetState();
}

class _CountriesListBottomSheetState extends State<CountriesListBottomSheet> {
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
      widget.countries.countries?.forEach((country) {
        if (country.name!.toLowerCase().contains(query.toLowerCase())) {
          filteredCountries.add(country);
        }
      });
    } else {
      filteredCountries.addAll(widget.countries.countries!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('length: ${widget.countries.countries!.length}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterList(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search Countries...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) => CountryFlagCard(
                countryName: filteredCountries[index].name!,
                imageUrl: filteredCountries[index].flag!,
                selectFromCountry: widget.selectFromCountry,
                selectToCountry: widget.selectToCountry,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
