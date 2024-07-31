import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';

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
    var response = await apiManager.createShipmentWithCheckAccessToken(
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
    var response = await apiManager.getAllShipmentsWithCheckAccessToken(
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
    var response =
        await apiManager.getMyShipmentsWithCheckAccessToken(accessToken: token);
    print('datasource');

    return response.toUserShipmentDto();
  }

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId}) async {
    var response = await apiManager.getMyShipmentDealsWithCheckAccessToken(
        accessToken: token, shipmentId: shipmentId);

    return response.toMyShipmentDealsResponseDto();
  }

  @override
  Future<TripDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId}) async {
    var response = await apiManager.sendTripDealWithCheckAccessToken(
        shipmentId: shipmentId,
        reward: reward,
        accessToken: token,
        tripId: tripId);

    return response.toTripDealResponseDto();
  }

  @override
  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) async {
    var response =
        await apiManager.getMyShipmentDealDetailsWithCheckAccessToken(
            accessToken: token, dealId: dealId);
    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> acceptShipmentDeal(
      {required String token,
      required String dealId,
      required String dealType,
      required String status}) async {
    var response = await apiManager.acceptShipmentDealWithCheckAccessToken(
        accessToken: token, dealId: dealId, status: status, dealType: dealType);

    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> rejectShipmentDeal(
      {required String token,
      required String dealId,
      required String dealType,
      required String status}) async {
    var response = await apiManager.rejectDealWithCheckAccessToken(
        accessToken: token, dealId: dealId, status: status, dealType: dealType);

    return response.toResponseDto();
  }

  @override
  Future<CounterOfferResponseDto> makeCounterOffer(
      {required String token,
      required int dealId,
      required double reward}) async {
    var response = await apiManager.makeCounterOfferWithCheckAccessToken(
        dealId: dealId, reward: reward, accessToken: token);

    return response.toResponseDto();
  }

  @override
  Future<CancelDealResponseDto> cancelDeal(
      {required String token, required int dealId}) async {
    var response =
        await apiManager.cancelDeal(dealId: dealId, accessToken: token);

    return response.toResponseDto();
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
