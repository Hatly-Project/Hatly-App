import 'dart:convert';

class CancelDealResponseDto {
  String? message;
  bool? status;

  CancelDealResponseDto({this.message, this.status});

  factory CancelDealResponseDto.fromMap(Map<String, dynamic> data) {
    return CancelDealResponseDto(
      message: data['message'] as String?,
      status: data['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CancelDealResponse].
  factory CancelDealResponseDto.fromJson(String data) {
    return CancelDealResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CancelDealResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
