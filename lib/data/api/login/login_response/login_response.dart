import 'dart:convert';

import 'package:hatly/domain/models/login_response_dto.dart';

import '../../register/register_response/user.dart';

class LoginResponse {
  String? token;
  String? message;

  User? user;
  bool? status;

  LoginResponse({this.token, this.user, this.status, this.message});

  factory LoginResponse.fromMap(Map<String, dynamic> data) => LoginResponse(
        token: data['token'] as String?,
        message: data['message'] as String?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'token': token,
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
        token: token,
        user: user?.toUserDto(),
        message: message,
        status: status);
  }
}
