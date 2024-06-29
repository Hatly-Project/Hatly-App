import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';

class ResetPasswordScreenArguments {
  String otp;
  CountriesDto countriesStatesDto;

  ResetPasswordScreenArguments(this.otp, this.countriesStatesDto);
}
