import 'package:hatly/data/api/trip_matching_shipments_response/trip_matching_shipments_response.dart';
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
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';

abstract class TripsRepository {
  Future<GetAllTripsResponseDto> getAllTrips(
      {required String token,
      String? beforeExpectedDate,
      String? afterExpectedDate,
      String? from,
      String? fromCity,
      String? to,
      String? toCity,
      bool? latest,
      int page = 1});

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
      required String token});

  Future<GetUserTripResponseDto> getUserTrip({required String token});

  Future<TripMatchingShipmentsResponseDto> getTripMatchingShipments(
      {required String token, required int tripId});
}
