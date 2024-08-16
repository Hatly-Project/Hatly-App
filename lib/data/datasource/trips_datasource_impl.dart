import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';
import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';

class TripsDatasourceImpl implements TripsDatasource {
  ApiManager apiManager;

  TripsDatasourceImpl(this.apiManager);

  @override
  Future<GetAllTripsResponseDto> getAllTrips(
      {required String token,
      String? beforeExpectedDate,
      String? afterExpectedDate,
      String? from,
      String? fromCity,
      String? to,
      String? toCity,
      bool? latest,
      int page = 1}) async {
    var response = await apiManager.getAllTripsWithCheckAccessToken(
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

    return response.toTripsResponseDto();
  }

  @override
  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      String? originCity,
      String? destinationCity,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfoDto? bookInfoDto,
      List<ItemsNotAllowedDto>? itemsNotAllowed,
      required String token}) async {
    var response = await apiManager.createTripWithCheckAccessToken(
        accessToken: token,
        origin: origin,
        originCity: originCity,
        destinationCity: destinationCity,
        departDate: departDate,
        destination: destination,
        available: available,
        bookInfo: bookInfoDto?.toBookInfo(),
        itemsNotAllowed:
            itemsNotAllowed?.map((item) => item.toItemsNotAllowed()).toList(),
        note: note,
        addressMeeting: addressMeeting);
    return response.toCreateTripResponseDto();
  }

  @override
  Future<GetUserTripResponseDto> getUserTrip({required String token}) async {
    var response =
        await apiManager.getUserTripsWithCheckAccessToken(accessToken: token);

    return response.toUserTripResponseDto();
  }

  @override
  Future<ShipmentDealResponseDto> sendDeal(
      {int? shipmentId,
      double? reward,
      required String token,
      required int tripId}) async {
    var response = await apiManager.sendShipmentDealWithCheckAccessToken(
        accessToken: token,
        tripId: tripId,
        shipmentId: shipmentId,
        reward: reward);

    return response.toShipmentDealResponseDto();
  }

  @override
  Future<TripMatchingShipmentsResponseDto> getTripMatchingShipments(
      {required String token, required int tripId}) async {
    var response =
        await apiManager.getTripsMatchingShipmentsWithCheckAccessToken(
            accessToken: token, tripId: tripId);

    return response.toDto();
  }

  @override
  Future<MyTripDealsResponseDto> getMyTripDeals(
      {required String token, required int tripId}) async {
    var respone = await apiManager.getMyTripDealsWithCheckAccessToken(
        accessToken: token, tripId: tripId);

    return respone.toDto();
  }

  @override
  Future<GetTripDealDetailsResponseDto> getMytripDealDetails(
      {required String token, required int dealId}) async {
    var response = await apiManager.getMyTripDealDetailsWithCheckAccessToken(
        accessToken: token, dealId: dealId.toString());

    return response.toDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> acceptTripDeal(
      {required String token,
      required String dealId,
      required String status,
      required String dealType}) async {
    var response = await apiManager.acceptShipmentDealWithCheckAccessToken(
        accessToken: token, dealId: dealId, status: status, dealType: dealType);

    return response.toResponseDto();
  }

  @override
  Future<AcceptOrRejectShipmentDealResponseDto> rejectTripDeal(
      {required String token,
      required String dealId,
      required String status,
      required String dealType}) async {
    var response = await apiManager.rejectShipmentDeal(
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
}
