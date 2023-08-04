import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/domain/models/user_model.dart';

class UserProvider extends Cubit<CurrentUserState> {
  UserProvider() : super(LoggedOutState());

  void login(LoggedInState loggedInState) {
    emit(loggedInState);
  }

  void logout(LoggedOutState loggedOutState) {
    emit(loggedOutState);
  }
}

abstract class CurrentUserState {}

class LoggedInState extends CurrentUserState {
  UserDto user;
  String token;

  LoggedInState({required this.user, required this.token});
}

class LoggedOutState extends CurrentUserState {}
