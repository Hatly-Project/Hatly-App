import 'dart:convert';

import 'package:hatly/data/api/shipmentDeal.dart';
import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/traveler_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class DealDto {
  static const collectionName = 'Deals';
  int? id;
  String? dealStatus;
  String? creatorEmail;
  double? counterReward, finalReward, hatlyFees, paymentFees;
  TravelerDto? traveler;
  TripsDto? trip;

  DealDto(
      {this.id,
      this.dealStatus,
      this.counterReward,
      this.finalReward,
      this.traveler,
      this.hatlyFees,
      this.paymentFees,
      this.trip,
      this.creatorEmail});

  factory DealDto.fromMap(Map<String, dynamic> data) => DealDto(
        id: data['id'] as int?,
        dealStatus: data['dealStatus'] as String?,
        creatorEmail: data['creatorEmail'] as String?,
        counterReward: (data['counterReward'] as num?)?.toDouble(),
        finalReward: (data['finalReward'] as num?)?.toDouble(),
        hatlyFees: (data['fees'] as num?)?.toDouble(),
        paymentFees: (data['paymentFees'] as num?)?.toDouble(),
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
        'counterReward': counterReward,
        'finalReward': finalReward,
        'traveler': traveler?.toMap(),
        'fees': hatlyFees,
        'paymentFees': paymentFees,
        'trip': trip?.toMap(),
      };

  DealDto.fromFirestore(Map<String, dynamic> data) {
    id = data['id'];
    dealStatus = data['dealStatus'];
    creatorEmail = data['creatorEmail'];
    counterReward = (data['counterReward'] as num?)?.toDouble();
    finalReward = (data['finalReward'] as num?)?.toDouble();
  }

  Map<String, dynamic> toFireStore() => {
        'id': id,
        'dealStatus': dealStatus,
        'creatorEmail': creatorEmail,
        'counterReward': counterReward,
        'finalReward': finalReward,
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
        counterReward: counterReward,
        hatlyFees: hatlyFees,
        paymentFees: paymentFees,
        finalReward: finalReward,
        traveler: traveler?.toTraveler(),
        trip: trip?.toTrip());
  }
}
