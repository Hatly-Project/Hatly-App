import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends Cubit<CurrentUserState> {
  late FlutterSecureStorage storage;
  UserProvider() : super(LoggedOutState()) {
    storage = FlutterSecureStorage();

    getIfUserLogin();
  }

  void login(LoggedInState loggedInState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

// Store tokens

    sharedPreferences.setBool('login', true);
    // sharedPreferences.setString('token', loggedInState.token);
    sharedPreferences.setString('userFirstName', loggedInState.user.firstName!);
    sharedPreferences.setString('userLastName', loggedInState.user.lastName!);

    sharedPreferences.setString('userEmail', loggedInState.user.email!);
    // sharedPreferences.setString('userPhone', loggedInState.user.phone!);
    sharedPreferences.setString(
        'userPhoto', loggedInState.user.profilePhoto ?? '');
    sharedPreferences.setString('userId', loggedInState.user.id ?? '');
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
    // Retrieve tokens
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');

    // String? token = sharedPreferences.getString('token');
    String? firstName = sharedPreferences.getString('userFirstName');
    String? lastName = sharedPreferences.getString('userLastName');

    String? email = sharedPreferences.getString('userEmail');
    String? phone = sharedPreferences.getString('userPhone');
    String? profilePhoto = sharedPreferences.getString('userPhoto');
    String? id = sharedPreferences.getString('userId');
    bool? isLogin = sharedPreferences.getBool('login') ?? false;
    print(isLogin);
    if (isLogin) {
      emit(LoggedInState(
          user: UserDto(
              firstName: firstName,
              lastName: lastName,
              phone: phone,
              email: email,
              profilePhoto: profilePhoto,
              id: id),
          accessToken: accessToken!,
          refreshToken: refreshToken!));
    }
  }

  void refreshAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// Store tokens
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');
    print('new access $accessToken');
    // String? token = sharedPreferences.getString('token');
    String? firstName = sharedPreferences.getString('userFirstName');
    String? lastName = sharedPreferences.getString('userLastName');

    String? email = sharedPreferences.getString('userEmail');
    String? phone = sharedPreferences.getString('userPhone');
    String? profilePhoto = sharedPreferences.getString('userPhoto');
    String? id = sharedPreferences.getString('userId');
    bool? isLogin = sharedPreferences.getBool('login') ?? false;

    emit(LoggedInState(
        user: UserDto(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: email,
            profilePhoto: profilePhoto,
            id: id),
        accessToken: accessToken!,
        refreshToken: refreshToken!));
  }
}

abstract class CurrentUserState {}

class LoggedInState extends CurrentUserState {
  UserDto user;
  String accessToken, refreshToken;

  LoggedInState(
      {required this.user,
      required this.accessToken,
      required this.refreshToken});
}

class LoggedOutState extends CurrentUserState {}
