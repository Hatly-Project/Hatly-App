import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  ShipmentDataSource shipmentDataSource;

  ShipmentRepositoryImpl(this.shipmentDataSource);
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
      required String token}) {
    print('note repo $note');
    return shipmentDataSource.createShipment(
        token: token,
        title: title,
        note: note,
        from: from,
        fromCity: fromCity,
        toCity: toCity,
        to: to,
        date: date,
        reward: reward,
        items: items);
  }

  @override
  Future<GetAllShipmentResponseDto> getAllShipments(String token) {
    return shipmentDataSource.getAllShipments(token);
  }

  @override
  Future<GetUserShipmentsDto> getUserShipments({required String token}) {
    return shipmentDataSource.getUserShipments(token: token);
  }

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId}) {
    return shipmentDataSource.getMyShipmentDeals(
        token: token, shipmentId: shipmentId);
  }

  @override
  Future<ShipmentDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId}) {
    return shipmentDataSource.sendDeal(
        token: token, shipmentId: shipmentId, reward: reward, tripId: tripId);
  }

  @override
  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) {
    return shipmentDataSource.getMyShipmentDealDetails(
        token: token, dealId: dealId);
  }
}
