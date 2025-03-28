import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';

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
        accessToken: token,
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
  Future<GetAllShipmentResponseDto> getAllShipments({
    required String token,
    int page = 1,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) async {
    var response = await apiManager.getAllShipments(
      accessToken: token,
      page: page,
      beforeExpectedDate: beforeExpectedDate,
      afterExpectedDate: afterExpectedDate,
      from: from,
      fromCity: fromCity,
      to: to,
      toCity: toCity,
      latest: latest,
    );
    return response.toGetAllShipmetnsDto();
  }

  @override
  Future<GetUserShipmentsDto> getUserShipments({required String token}) async {
    var response = await apiManager.getUserShipments(accessToken: token);
    print('datasource');

    return response.toUserShipmentDto();
  }

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId}) async {
    var response = await apiManager.getMyShipmentDeals(
        accessToken: token, shipmentId: shipmentId);

    return response.toMyShipmentDealsResponseDto();
  }

  // @override
  // Future<ShipmentMatchingTripsResponseDto> getShipmentMatchingTrips(
  //     {required String token, int? shipmentId}) async {
  //   var response =
  //       await apiManager.getShipmentMatchingTripsWithCheckAccessToken(
  //           accessToken: token, shipmentId: shipmentId);
  //   return response.toDto();
  // }
}
