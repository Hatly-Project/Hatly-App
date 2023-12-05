import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

import '../models/item_dto.dart';

class CreateShipmentUsecase {
  ShipmentRepository shipmentRepository;

  CreateShipmentUsecase(this.shipmentRepository);

  Future<CreateShipmentsResponseDto> invoke(
      {String? title,
      String? from,
      String? to,
      String? note,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token}) async {
    print('note use $note');
    return shipmentRepository.createShipment(
        title: title,
        from: from,
        to: to,
        note: note,
        date: date,
        reward: reward,
        items: items,
        token: token);
  }
}
