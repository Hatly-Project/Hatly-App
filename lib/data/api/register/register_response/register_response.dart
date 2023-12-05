import 'dart:convert';

import 'package:hatly/domain/models/register_response_dto.dart';
import 'package:hatly/domain/models/user_model.dart';

import 'user.dart';

class RegisterResponse {
  bool? status;
  String? message;
  User? user;

  RegisterResponse({this.status, this.user, this.message});

  factory RegisterResponse.fromMap(Map<String, dynamic> data) {
    return RegisterResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'user': user?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterResponse].
  factory RegisterResponse.fromJson(String data) {
    return RegisterResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  RegisterResponseDto toRegisterDto() {
    return RegisterResponseDto(
        status: status, message: message, user: toUserDto());
  }

  UserDto toUserDto() {
    return UserDto(
        name: user?.name,
        phone: user?.phone,
        email: user?.email,
        profilePhoto: user?.profilePhoto);
  }
}
