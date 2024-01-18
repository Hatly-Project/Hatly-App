import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';

abstract class TripsRepository {
  Future<GetAllTripsResponseDto> getAllTrips(String token);

  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfoDto? bookInfoDto,
      List<ItemsNotAllowedDto>? itemsNotAllowed,
      required String token});

  Future<GetUserTripResponseDto> getUserTrip({required String token});

  Future<TripDealResponseDto> sendDeal(
      {List<ShipmentDto>? shipments,
      double? reward,
      required String token,
      required int tripId});
}
