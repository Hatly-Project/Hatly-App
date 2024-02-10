import 'dart:convert';

import 'package:hatly/data/api/shipments/my_shipment_deals_response/deal.dart';
import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/traveler_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class DealDto {
  int? id;
  String? dealStatus;
  String? creatorEmail;
  int? reward;
  TravelerDto? traveler;
  TripsDto? trip;

  DealDto(
      {this.id,
      this.dealStatus,
      this.reward,
      this.traveler,
      this.trip,
      this.creatorEmail});

  factory DealDto.fromMap(Map<String, dynamic> data) => DealDto(
        id: data['id'] as int?,
        dealStatus: data['dealStatus'] as String?,
        creatorEmail: data['creatorEmail'] as String?,
        reward: data['reward'] as int?,
        traveler: data['traveler'] == null
            ? null
            : TravelerDto.fromMap(data['traveler'] as Map<String, dynamic>),
        trip: data['trip'] == null
            ? null
            : TripsDto.fromMap(data['trip'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'dealStatus': dealStatus,
        'creatorEmail': creatorEmail,
        'reward': reward,
        'traveler': traveler?.toMap(),
        'trip': trip?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DealDto].
  factory DealDto.fromJson(String data) {
    return DealDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DealDto] to a JSON string.
  String toJson() => json.encode(toMap());

  Deal toDeal() {
    return Deal(
        id: id,
        dealStatus: dealStatus,
        creatorEmail: creatorEmail,
        reward: reward,
        traveler: traveler?.toTraveler(),
        trip: trip?.toTrip());
  }
}
