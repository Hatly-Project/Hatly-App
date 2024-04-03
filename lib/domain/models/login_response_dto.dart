import 'package:hatly/domain/models/user_model.dart';

class LoginResponseDto {
  String? accessToken;
  String? message;
  UserDto? user;
  bool? status;

  LoginResponseDto({this.accessToken, this.user, this.status, this.message});
}
