import 'package:hatly/domain/models/get_all_shipments_dto.dart';

import '../models/create_shipment_response_dto.dart';
import '../models/item_dto.dart';

abstract class ShipmentRepository {
  Future<CreateShipmentsResponseDto> createShipment(
      {String? title,
      String? note,
      String? from,
      String? to,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token});

  Future<GetAllShipmentResponseDto> getAllShipments();
}
