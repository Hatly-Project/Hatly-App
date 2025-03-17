import 'dart:convert';

class DealResponseDto {
  bool? status;
  String? message;

  DealResponseDto({this.status, this.message});

  factory DealResponseDto.fromMap(Map<String, dynamic> data) {
    return DealResponseDto(
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
  factory DealResponseDto.fromJson(String data) {
    return DealResponseDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
