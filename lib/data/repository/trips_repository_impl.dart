import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  TripsDatasource tripsDatasource;

  TripsRepositoryImpl(this.tripsDatasource);

  @override
  Future<GetAllTripsResponseDto> getAllTrips() {
    return tripsDatasource.getAllTrips();
  }
}
