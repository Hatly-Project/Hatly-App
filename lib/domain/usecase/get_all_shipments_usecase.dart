import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetAllShipmentsUsecase {
  ShipmentRepository shipmentRepository;

  GetAllShipmentsUsecase(this.shipmentRepository);

  Future<GetAllShipmentResponseDto> invoke(
      {required String token, int page = 1}) {
    return shipmentRepository.getAllShipments(token: token, page: page);
  }
}
