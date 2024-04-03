import 'dart:convert';

import 'package:hatly/data/api/user.dart';
import 'package:hatly/domain/models/login_response_dto.dart';

class LoginResponse {
  String? accessToken;
  String? message;

  User? user;
  bool? status;

  LoginResponse({this.accessToken, this.user, this.status, this.message});

  factory LoginResponse.fromMap(Map<String, dynamic> data) => LoginResponse(
        accessToken: data['accessToken'] as String?,
        message: data['message'] as String?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'accessToken': accessToken,
        'message': message,
        'user': user?.toMap(),
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginResponse].
  factory LoginResponse.fromJson(String data) {
    return LoginResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  LoginResponseDto toLoginDto() {
    return LoginResponseDto(
        accessToken: accessToken,
        user: user?.toUserDto(),
        message: message,
        status: status);
  }
}
