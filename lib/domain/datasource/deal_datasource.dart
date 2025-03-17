import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';

abstract class DealDatasource {
  Future<MyTripDealsResponseDto> getMyTripDeals(
      {required String token, required int tripId});

  Future<GetTripDealDetailsResponseDto> getMytripDealDetails(
      {required String token, required int dealId});

  Future<AcceptOrRejectShipmentDealResponseDto> acceptDeal(
      {required String token,
      required String dealId,
      required String dealType});

  Future<DealResponseDto> sendDeal(
      {String? shipmentId,
      double? reward,
      required String token,
      required String tripId});
  Future<AcceptOrRejectShipmentDealResponseDto> rejectDeal(
      {required String token,
      required String dealId,
      required String dealType});

  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token, required int dealId, required double reward});

  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId});
}
