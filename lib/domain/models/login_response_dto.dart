import 'package:hatly/domain/models/user_model.dart';

class LoginResponseDto {
  String? token;
  String? message;
  UserDto? user;
  bool? status;

  LoginResponseDto({this.token, this.user, this.status, this.message});
}
