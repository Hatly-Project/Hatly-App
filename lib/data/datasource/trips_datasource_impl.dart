import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';

class TripsDatasourceImpl implements TripsDatasource {
  ApiManager apiManager;

  TripsDatasourceImpl(this.apiManager);

  @override
  Future<GetAllTripsResponseDto> getAllTrips(String token) async {
    var response = await apiManager.getAllTrips(token: token);

    return response.toTripsResponseDto();
  }

  @override
  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      String? notNeed,
      required String token}) async {
    var response = await apiManager.createTrip(
        token: token,
        origin: origin,
        departDate: departDate,
        destination: destination,
        available: available,
        notNeed: notNeed,
        note: note,
        addressMeeting: addressMeeting);
    return response.toCreateTripResponseDto();
  }
}
