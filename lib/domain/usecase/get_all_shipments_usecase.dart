import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetAllShipmentsUsecase {
  ShipmentRepository shipmentRepository;

  GetAllShipmentsUsecase(this.shipmentRepository);

  Future<GetAllShipmentResponseDto> invoke({
    required String token,
    int page = 1,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) {
    return shipmentRepository.getAllShipments(
      token: token,
      page: page,
      beforeExpectedDate: beforeExpectedDate,
      afterExpectedDate: afterExpectedDate,
      from: from,
      fromCity: fromCity,
      to: to,
      toCity: toCity,
      latest: latest,
    );
  }
}
