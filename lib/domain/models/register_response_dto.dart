import 'package:hatly/domain/models/user_model.dart';

class RegisterResponseDto {
  bool? status;
  String? message;
  UserDto? user;

  RegisterResponseDto({this.status, this.user, this.message});
}
