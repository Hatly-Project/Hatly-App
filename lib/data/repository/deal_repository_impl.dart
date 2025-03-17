import 'package:hatly/domain/datasource/deal_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/deal_repository.dart';

class DealRepositoryImpl implements DealRepository {
  DealDatasource dealDatasource;

  DealRepositoryImpl(this.dealDatasource);
  @override
  Future<AcceptOrRejectShipmentDealResponseDto> acceptDeal(
      {required String token,
      required String dealId,
      required String dealType}) {
    return dealDatasource.acceptDeal(
        token: token, dealId: dealId, dealType: dealType);
  }

  @override
  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) {
    return dealDatasource.getMyShipmentDealDetails(
        token: token, dealId: dealId);
  }

  @override
  Future<MyTripDealsResponseDto> getMyTripDeals(
      {required String token, required int tripId}) {
    return dealDatasource.getMyTripDeals(token: token, tripId: tripId);
  }

  @override
  Future<GetTripDealDetailsResponseDto> getMytripDealDetails(
      {required String token, required int dealId}) {
    return dealDatasource.getMytripDealDetails(token: token, dealId: dealId);
  }

  @override
  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token, required int dealId, required double reward}) {
    return dealDatasource.makeCounterOffer(
        token: token, dealId: dealId, reward: reward);
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> rejectDeal(
      {required String token,
      required String dealId,
      required String dealType}) {
    return dealDatasource.rejectDeal(
        token: token, dealId: dealId, dealType: dealType);
  }

  @override
  Future<DealResponseDto> sendDeal(
      {String? shipmentId,
      double? reward,
      required String token,
      required String tripId}) {
    return dealDatasource.sendDeal(
        shipmentId: shipmentId, reward: reward, token: token, tripId: tripId);
  }
}
