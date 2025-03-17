import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/deal_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';

class DealDatasourceImpl implements DealDatasource {
  ApiManager apiManager;

  DealDatasourceImpl({required this.apiManager});
  @override
  Future<AcceptOrRejectShipmentDealResponseDto> acceptDeal(
      {required String token,
      required String dealId,
      required String dealType}) async {
    var response = await apiManager.changeDealStatus(
        accessToken: token, dealId: dealId, status: "accepted");

    return response.toResponseDto();
  }

  @override
  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) async {
    var response = await apiManager.getMyShipmentDealDetails(
        accessToken: token, dealId: dealId);

    return response.toResponseDto();
  }

  @override
  Future<MyTripDealsResponseDto> getMyTripDeals(
      {required String token, required int tripId}) {
    // TODO: implement getMyTripDeals
    throw UnimplementedError();
  }

  @override
  Future<GetTripDealDetailsResponseDto> getMytripDealDetails(
      {required String token, required int dealId}) async {
    var response = await apiManager.getMyTripDealDetails(
        accessToken: token, dealId: dealId.toString());
    return response.toDto();
  }

  @override
  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token,
      required int dealId,
      required double reward}) async {
    var response = await apiManager.makeCounterOffer(
        dealId: dealId, reward: reward, accessToken: token);
    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> rejectDeal(
      {required String token,
      required String dealId,
      required String dealType}) async {
    var response = await apiManager.changeDealStatus(
        accessToken: token, dealId: dealId, status: "rejected");
    return response.toResponseDto();
  }

  @override
  Future<DealResponseDto> sendDeal(
      {String? shipmentId,
      double? reward,
      required String token,
      required String tripId}) async {
    var response = await apiManager.sendDeal(
        accessToken: token,
        tripId: tripId,
        reward: reward,
        shipmentId: shipmentId);
    return response.toDto();
  }
}
