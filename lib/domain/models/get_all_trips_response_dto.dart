import 'package:hatly/domain/models/trips_dto.dart';

class GetAllTripsResponseDto {
  bool? status;
  List<TripsDto>? trips;
  String? message;
  int? totalPages, totalData;

  GetAllTripsResponseDto(
      {this.status, this.trips, this.message, this.totalPages, this.totalData});
}
