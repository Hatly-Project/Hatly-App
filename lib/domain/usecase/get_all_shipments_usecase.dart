import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetAllShipmentsUsecase {
  ShipmentRepository shipmentRepository;

  GetAllShipmentsUsecase(this.shipmentRepository);

  Future<GetAllShipmentResponseDto> invoke(String token) {
    return shipmentRepository.getAllShipments(token);
  }
}
