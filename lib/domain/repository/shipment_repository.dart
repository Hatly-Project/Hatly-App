import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';

import '../models/create_shipment_response_dto.dart';
import '../models/item_dto.dart';

abstract class ShipmentRepository {
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

  Future<GetAllShipmentResponseDto> getAllShipments(
      {required String token, int page = 1});
  Future<GetUserShipmentsDto> getUserShipments({required String token});

  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId});

  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId});

  Future<TripDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId});

  Future<AcceptOrRejectShipmentDealResponseDto> acceptShipmentDeal(
      {required String token,
      required String dealId,
      required String status,
      required String dealType});

  Future<AcceptOrRejectShipmentDealResponseDto> rejectShipmentDeal(
      {required String token,
      required String dealId,
      required String status,
      required String dealType});

  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token, required int dealId, required double reward});

  Future<CancelDealResponseDto> cancelDeal(
      {required String token, required int dealId});

  Future<ShipmentMatchingTripsResponseDto> getShipmentMatchingTrips(
      {required String token, required int shipmentId});
}
