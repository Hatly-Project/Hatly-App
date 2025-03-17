import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
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
    var response = await apiManager.getAllTrips(
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
    var response = await apiManager.createTrip(
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
    var response = await apiManager.getUserTrips(accessToken: token);

    return response.toUserTripResponseDto();
  }

  @override
  Future<TripMatchingShipmentsResponseDto> getTripMatchingShipments(
      {required String token, required int tripId}) async {
    var response = await apiManager.getTripsMatchingShipments(
        accessToken: token, tripId: tripId);

    return response.toDto();
  }
}
