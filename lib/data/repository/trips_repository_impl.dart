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
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  TripsDatasource tripsDatasource;

  TripsRepositoryImpl(this.tripsDatasource);

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
      int page = 1}) {
    return tripsDatasource.getAllTrips(
        token: token,
        page: page,
        beforeExpectedDate: beforeExpectedDate,
        afterExpectedDate: afterExpectedDate,
        from: from,
        fromCity: fromCity,
        to: to,
        latest: latest,
        toCity: toCity);
  }

  @override
  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      int? available,
      String? originCity,
      String? destinationCity,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfoDto? bookInfoDto,
      List<ItemsNotAllowedDto>? itemsNotAllowed,
      required String token}) {
    return tripsDatasource.createTrip(
        token: token,
        origin: origin,
        destination: destination,
        originCity: originCity,
        destinationCity: destinationCity,
        available: available,
        note: note,
        addressMeeting: addressMeeting,
        departDate: departDate,
        bookInfoDto: bookInfoDto,
        itemsNotAllowed: itemsNotAllowed);
  }

  @override
  Future<GetUserTripResponseDto> getUserTrip({required String token}) {
    return tripsDatasource.getUserTrip(token: token);
  }

  @override
  Future<TripMatchingShipmentsResponseDto> getTripMatchingShipments(
      {required String token, required int tripId}) {
    return tripsDatasource.getTripMatchingShipments(
        token: token, tripId: tripId);
  }
}
