import 'dart:convert';

class UpdateProfileRequest {
  String? dob;
  String? address;
  String? city;
  String? country;
  String? phone;
  String? postalCode;
  String? ip;

  UpdateProfileRequest({
    this.dob,
    this.address,
    this.city,
    this.country,
    this.phone,
    this.postalCode,
    this.ip,
  });

  factory UpdateProfileRequest.fromMap(Map<String, dynamic> data) {
    return UpdateProfileRequest(
      dob: data['dob'] as String?,
      address: data['address'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
      phone: data['phone'] as String?,
      postalCode: data['postalCode'] as String?,
      ip: data['ip'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'dob': dob,
        'address': address,
        'city': city,
        'country': country,
        'phone': phone,
        'postalCode': postalCode,
        'ip': ip,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UpdateProfileRequest].
  factory UpdateProfileRequest.fromJson(String data) {
    return UpdateProfileRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UpdateProfileRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
