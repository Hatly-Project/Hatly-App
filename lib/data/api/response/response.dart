import 'dart:convert';

import 'trip.dart';

class Response {
  bool? status;
  List<Trip>? trips;

  Response({this.status, this.trips});

  factory Response.fromMap(Map<String, dynamic> data) => Response(
        status: data['status'] as bool?,
        trips: (data['trips'] as List<dynamic>?)
            ?.map((e) => Trip.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'trips': trips?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Response].
  factory Response.fromJson(String data) {
    return Response.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Response] to a JSON string.
  String toJson() => json.encode(toMap());
}
