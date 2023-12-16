import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetUserShipmentUsecase {
  ShipmentRepository repository;

  GetUserShipmentUsecase(this.repository);

  Future<GetUserShipmentsDto> invoke({required String token}) {
    return repository.getUserShipments(token: token);
  }
}
