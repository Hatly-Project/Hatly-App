import 'package:hatly/domain/models/trips_dto.dart';

class CreateTripResponseDto {
  bool? status;
  TripsDto? trip;
  String? message;

  CreateTripResponseDto({this.status, this.trip, this.message});
}
