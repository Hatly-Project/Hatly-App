import 'package:hatly/domain/models/shipment_dto.dart';

class GetAllShipmentResponseDto {
  bool? status;
  String? message;

  List<ShipmentDto>? shipments;

  GetAllShipmentResponseDto({this.status, this.shipments, this.message});
}
