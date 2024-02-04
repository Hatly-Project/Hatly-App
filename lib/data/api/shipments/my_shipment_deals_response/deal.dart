import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/deal_dto.dart';

import 'traveler.dart';

class Deal {
  int? id;
  String? dealStatus;
  int? reward;
  Traveler? traveler;
  Trip? trip;

  Deal({this.id, this.dealStatus, this.reward, this.traveler, this.trip});

  factory Deal.fromMap(Map<String, dynamic> data) => Deal(
        id: data['id'] as int?,
        dealStatus: data['dealStatus'] as String?,
        reward: data['reward'] as int?,
        traveler: data['traveler'] == null
            ? null
            : Traveler.fromMap(data['traveler'] as Map<String, dynamic>),
        trip: data['trip'] == null
            ? null
            : Trip.fromMap(data['trip'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'dealStatus': dealStatus,
        'reward': reward,
        'traveler': traveler?.toMap(),
        'trip': trip?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Deal].
  factory Deal.fromJson(String data) {
    return Deal.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Deal] to a JSON string.
  String toJson() => json.encode(toMap());

  DealDto toDealDto() {
    return DealDto(
        id: id,
        dealStatus: dealStatus,
        reward: reward,
        traveler: traveler?.toTravelerDto(),
        trip: trip?.toTripsDto());
  }
}
