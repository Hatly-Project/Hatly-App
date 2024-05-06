import 'dart:convert';

import 'package:hatly/data/api/trips/my_trip_deals_response/deal.dart';
import 'package:hatly/domain/models/trip_deal_dto.dart';

class MyTripDealsResponseDto {
  bool? status;
  String? message;
  List<TripDealDto>? deals;

  MyTripDealsResponseDto({this.status, this.deals, this.message});

  factory MyTripDealsResponseDto.fromMap(Map<String, dynamic> data) {
    return MyTripDealsResponseDto(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      deals: (data['deals'] as List<dynamic>?)
          ?.map((e) => TripDealDto.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'deals': deals?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MyTripDealsResponseDto].
  factory MyTripDealsResponseDto.fromJson(String data) {
    return MyTripDealsResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MyTripDealsResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
