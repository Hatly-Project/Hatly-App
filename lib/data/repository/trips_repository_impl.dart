import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  TripsDatasource tripsDatasource;

  TripsRepositoryImpl(this.tripsDatasource);

  @override
  Future<GetAllTripsResponseDto> getAllTrips(String token) {
    return tripsDatasource.getAllTrips(token);
  }

  @override
  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      int? available,
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
}
