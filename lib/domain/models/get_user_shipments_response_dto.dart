import 'package:hatly/data/api/shipments/create_shipments_response/shipment.dart';
import 'package:hatly/domain/models/shipment_dto.dart';

class GetUserShipmentsDto {
  bool? status;
  List<ShipmentDto>? shipments;
  String? message;

  GetUserShipmentsDto({this.message, this.shipments, this.status});
}
