import 'package:hatly/domain/models/shipment_dto.dart';

class GetUserShipmentsDto {
  bool? status;
  List<ShipmentDto>? shipments;
  String? message;

  GetUserShipmentsDto({this.message, this.shipments, this.status});
}
