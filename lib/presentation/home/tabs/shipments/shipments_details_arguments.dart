import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';

class ShipmentDetailsArguments {
  ShipmentDto shipmentDto;
  List<CountriesStatesDto>? countriesStatesDto;

  ShipmentDetailsArguments(
      {required this.shipmentDto, this.countriesStatesDto});
}
