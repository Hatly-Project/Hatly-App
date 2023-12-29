import 'package:hatly/domain/models/trips_dto.dart';

class GetAllTripsResponseDto {
  bool? status;
  List<TripsDto>? trips;
  String? message;

  GetAllTripsResponseDto({this.status, this.trips, this.message});
}
