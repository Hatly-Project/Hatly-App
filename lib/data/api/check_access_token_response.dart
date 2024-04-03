import 'dart:convert';

class CheckAccessTokenResponse {
  bool? status;

  CheckAccessTokenResponse({this.status});

  factory CheckAccessTokenResponse.fromMap(Map<String, dynamic> data) {
    return CheckAccessTokenResponse(
      status: data['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CheckAccessTokenResponse].
  factory CheckAccessTokenResponse.fromJson(String data) {
    return CheckAccessTokenResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CheckAccessTokenResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
