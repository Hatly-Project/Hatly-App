import 'package:hatly/domain/models/country_dto.dart';

class CountriesFlagsDto {
  bool? error;
  String? msg;
  List<CountryDto>? countries;

  CountriesFlagsDto({this.countries, this.error, this.msg});
}
