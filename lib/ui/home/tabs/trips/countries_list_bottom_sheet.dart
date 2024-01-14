import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_flags_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/ui/components/country_flag_card.dart';

class CountriesListBottomSheet extends StatefulWidget {
  List<CountryDto> countries;
  CountriesListBottomSheet({required this.countries});

  @override
  State<CountriesListBottomSheet> createState() =>
      _CountriesListBottomSheetState();
}

class _CountriesListBottomSheetState extends State<CountriesListBottomSheet> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        controller: scrollController,
        itemCount: widget.countries.length,
        itemBuilder: (context, index) => CountryFlagCard(
          countryName: widget.countries[index].name!,
          imageUrl: widget.countries[index].flag!,
        ),
      ),
    );
  }
}
