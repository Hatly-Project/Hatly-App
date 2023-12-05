import 'package:hatly/domain/models/shipment_dto.dart';

class CreateShipmentsResponseDto {
  bool? status;
  String? message;
  ShipmentDto? shipment;

  CreateShipmentsResponseDto({this.status, this.shipment, this.message});
}
