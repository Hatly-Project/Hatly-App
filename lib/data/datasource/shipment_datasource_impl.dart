import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';

class ShipmentDataSourceImpl implements ShipmentDataSource {
  ApiManager apiManager;

  ShipmentDataSourceImpl(this.apiManager);

  @override
  Future<CreateShipmentsResponseDto> createShipment(
      {String? title,
      String? note,
      String? from,
      String? fromCity,
      String? toCity,
      String? to,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token}) async {
    print('item data: $note');
    var response = await apiManager.createShipment(
        token: token,
        title: title,
        note: note,
        from: from,
        fromCity: fromCity,
        toCity: toCity,
        to: to,
        date: date,
        reward: reward,
        items: items?.map((item) => item.toItem()).toList());

    return response.toShipmentResponseDto();
  }

  @override
  Future<GetAllShipmentResponseDto> getAllShipments(String token) async {
    var response = await apiManager.getAllShipments(token: token);
    return response.toGetAllShipmetnsDto();
  }

  @override
  Future<GetUserShipmentsDto> getUserShipments({required String token}) async {
    var response = await apiManager.getUserShipments(token: token);
    print('datasource');

    return response.toUserShipmentDto();
  }
}
