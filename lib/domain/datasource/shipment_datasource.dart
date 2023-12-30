import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';

import '../models/get_all_shipments_dto.dart';

abstract class ShipmentDataSource {
  Future<CreateShipmentsResponseDto> createShipment(
      {String? title,
      String? note,
      String? from,
      String? to,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token});

  Future<GetAllShipmentResponseDto> getAllShipments(String token);

  Future<GetUserShipmentsDto> getUserShipments({required String token});
}
