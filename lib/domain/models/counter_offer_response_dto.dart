import 'dart:convert';

class CounterOfferResponseDto {
  String? message;
  bool? status;

  CounterOfferResponseDto({this.message, this.status});

  factory CounterOfferResponseDto.fromMap(Map<String, dynamic> data) =>
      CounterOfferResponseDto(
        message: data['message'] as String?,
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CounterOfferResponseDto].
  factory CounterOfferResponseDto.fromJson(String data) {
    return CounterOfferResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CounterOfferResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
