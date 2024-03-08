import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';

import '../models/get_all_shipments_dto.dart';

abstract class ShipmentDataSource {
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
      required String token});

  Future<GetAllShipmentResponseDto> getAllShipments(String token);

  Future<GetUserShipmentsDto> getUserShipments({required String token});

  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId});

  Future<ShipmentDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId});

  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId});

  Future<AcceptOrRejectShipmentDealResponseDto> acceptShipmentDeal(
      {required String token, required String dealId, required String status});

  Future<AcceptOrRejectShipmentDealResponseDto> rejectShipmentDeal(
      {required String token, required String dealId, required String status});

  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token, required int dealId, required double reward});
}
