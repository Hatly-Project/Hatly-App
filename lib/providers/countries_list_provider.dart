import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';

class CountriesListProvider extends ChangeNotifier {
  CountriesDto? countries;

  void setCountriesList({required CountriesDto countries}) {
    this.countries = countries;
    notifyListeners();
  }
}
