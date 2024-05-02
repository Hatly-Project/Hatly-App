import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';

class MyShipmentDealDetailsArgument {
  DealDto? dealDto;
  ShipmentDto? shipmentDto;

  MyShipmentDealDetailsArgument({this.dealDto, this.shipmentDto});
}
