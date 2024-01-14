import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends Cubit<CurrentUserState> {
  UserProvider() : super(LoggedOutState()) {
    getIfUserLogin();
  }

  void login(LoggedInState loggedInState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('login', true);
    sharedPreferences.setString('token', loggedInState.token);
    sharedPreferences.setString('userName', loggedInState.user.name!);
    sharedPreferences.setString('userEmail', loggedInState.user.email!);
    sharedPreferences.setString('userPhone', loggedInState.user.phone!);
    sharedPreferences.setString(
        'userPhoto', loggedInState.user.profilePhoto ?? '');
    sharedPreferences.setInt('userId', loggedInState.user.id ?? 0);
    // sharedPreferences.setString('userReview', loggedInState.user.r!);

    emit(loggedInState);
  }

  void logout(LoggedOutState loggedOutState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('login', false);
    emit(loggedOutState);
  }

  void getIfUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    String? name = sharedPreferences.getString('userName');
    String? email = sharedPreferences.getString('userEmail');
    String? phone = sharedPreferences.getString('userPhone');
    String? profilePhoto = sharedPreferences.getString('userPhoto');
    int? id = sharedPreferences.getInt('userId');
    bool? isLogin = sharedPreferences.getBool('login') ?? false;
    print(isLogin);
    if (isLogin) {
      emit(LoggedInState(
          user: UserDto(
              name: name,
              phone: phone,
              email: email,
              profilePhoto: profilePhoto,
              id: id),
          token: token!));
    }
  }
}

abstract class CurrentUserState {}

class LoggedInState extends CurrentUserState {
  UserDto user;
  String token;

  LoggedInState({required this.user, required this.token});
}

class LoggedOutState extends CurrentUserState {}
