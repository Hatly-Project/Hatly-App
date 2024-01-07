import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class CreateTripUsecase {
  TripsRepository repository;

  CreateTripUsecase(this.repository);

  Future<CreateTripResponseDto> invoke(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfoDto? bookInfoDto,
      List<ItemsNotAllowedDto>? itemsNotAllowed,
      required String token}) async {
    return repository.createTrip(
        token: token,
        origin: origin,
        destination: destination,
        available: available,
        bookInfoDto: bookInfoDto,
        itemsNotAllowed: itemsNotAllowed,
        note: note,
        addressMeeting: addressMeeting,
        departDate: departDate);
  }
}
