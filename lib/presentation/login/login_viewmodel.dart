import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/auth_datasoruce_impl.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/repository/auth_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';
import 'package:hatly/domain/usecase/login_google_usecase.dart';
import 'package:hatly/domain/usecase/login_usecase.dart';
import 'package:hatly/domain/usecase/register_usecase.dart';

import '../../domain/models/user_model.dart';

class LoginViewModel extends Cubit<LoginViewState> {
  late ApiManager apiManager;
  late AuthRepository authRepository;
  late AuthDataSource authDataSource;
  late LoginUseCase loginUseCase;
  late LoginWithGoogleUseCase loginWithGoogleUseCase;
  LoginViewModel() : super(LoginInitialState()) {
    apiManager = ApiManager();
    authDataSource = AuthDataSourceImpl(apiManager);
    authRepository = AuthRepositoryImpl(authDataSource);
    loginUseCase = LoginUseCase(authRepository);
    loginWithGoogleUseCase = LoginWithGoogleUseCase(authRepository);
  }

  void login(String email, String password) async {
    emit(LoginLoadingState('Loading...'));

    try {
      var response = await loginUseCase.invoke(email, password);
      // createUserInDb(user);
      emit(LoginSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(LoginFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }

  void loginWithGoogle(String idToken) async {
    emit(LoginLoadingState('Loading...'));

    try {
      var response = await loginWithGoogleUseCase.invoke(idToken);
      // createUserInDb(user);
      emit(LoginSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(LoginFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }
}

abstract class LoginViewState {}

class LoginInitialState extends LoginViewState {}

class LoginSuccessState extends LoginViewState {
  LoginResponseDto loginResponseDto;

  LoginSuccessState(this.loginResponseDto);
}

class LoginLoadingState extends LoginViewState {
  String loadingMessage;

  LoginLoadingState(this.loadingMessage);
}

class LoginFailState extends LoginViewState {
  String failMessage;

  LoginFailState(this.failMessage);
}
