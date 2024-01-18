import 'dart:convert';

class TripDealResponseDto {
  bool? status;
  String? message;

  TripDealResponseDto({this.status, this.message});

  factory TripDealResponseDto.fromMap(Map<String, dynamic> data) {
    return TripDealResponseDto(
      status: data['status'] as bool?,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TripDealResponseDto].
  factory TripDealResponseDto.fromJson(String data) {
    return TripDealResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
