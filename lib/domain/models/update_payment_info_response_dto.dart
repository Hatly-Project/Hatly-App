import 'dart:convert';

class UpdatePaymentInfoResponseDto {
  String? message;
  bool? status;

  UpdatePaymentInfoResponseDto({this.message, this.status});

  factory UpdatePaymentInfoResponseDto.fromMap(Map<String, dynamic> data) {
    return UpdatePaymentInfoResponseDto(
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
  /// Parses the string and returns the resulting Json object as [UpdatePaymentInfoResponseDto].
  factory UpdatePaymentInfoResponseDto.fromJson(String data) {
    return UpdatePaymentInfoResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UpdatePaymentInfoResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
