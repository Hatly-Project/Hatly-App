import 'dart:convert';

class ShipmentDealResponseDto {
  bool? status;
  String? message;

  ShipmentDealResponseDto({this.status, this.message});

  factory ShipmentDealResponseDto.fromMap(Map<String, dynamic> data) {
    return ShipmentDealResponseDto(
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
  /// Parses the string and returns the resulting Json object as [ShipmentDealResponseDto].
  factory ShipmentDealResponseDto.fromJson(String data) {
    return ShipmentDealResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShipmentDealResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
