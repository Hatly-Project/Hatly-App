import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';

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

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId}) async {
    var response = await apiManager.getMyShipmentDeals(
        token: token, shipmentId: shipmentId);

    return response.toMyShipmentDealsResponseDto();
  }

  @override
  Future<ShipmentDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId}) async {
    var response = await apiManager.sendShipmentDeal(
        shipmentId: shipmentId, reward: reward, token: token, tripId: tripId);

    return response.toShipmentDealResponseDto();
  }

  @override
  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) async {
    var response =
        await apiManager.getMyShipmentDealDetails(token: token, dealId: dealId);

    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> acceptShipmentDeal(
      {required String token,
      required String dealId,
      required String status}) async {
    var response = await apiManager.acceptShipmentDeal(
        token: token, dealId: dealId, status: status);

    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> rejectShipmentDeal(
      {required String token,
      required String dealId,
      required String status}) async {
    var response = await apiManager.rejectShipmentDeal(
        token: token, dealId: dealId, status: status);

    return response.toResponseDto();
  }

  @override
  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token,
      required int dealId,
      required double reward}) async {
    var response = await apiManager.makeCounterOffer(
        dealId: dealId, reward: reward, token: token);

    return response.toResponseDto();
  }
}
