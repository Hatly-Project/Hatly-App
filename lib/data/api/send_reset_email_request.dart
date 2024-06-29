import 'dart:convert';

class SendResetEmailRequest {
  String? email;
  bool? ar;

  SendResetEmailRequest({this.email, this.ar});

  factory SendResetEmailRequest.fromMap(Map<String, dynamic> data) {
    return SendResetEmailRequest(
      email: data['email'] as String?,
      ar: data['ar'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'ar': ar,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SendResetEmailRequest].
  factory SendResetEmailRequest.fromJson(String data) {
    return SendResetEmailRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SendResetEmailRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
