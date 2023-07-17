import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/auth_datasoruce_impl.dart';
import 'package:hatly/data/firebase/firebase_manager.dart';
import 'package:hatly/data/repository/auth_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/repository/auth_repository.dart';
import 'package:hatly/domain/usecase/login_usecase.dart';
import 'package:hatly/domain/usecase/register_usecase.dart';

import '../../domain/models/user_model.dart';

class LoginViewModel extends Cubit<LoginViewState> {
  late FirebaseManager firebaseManager;
  late AuthRepository authRepository;
  late AuthDataSource authDataSource;
  late LoginUseCase loginUseCase;
  LoginViewModel() : super(LoginInitialState()) {
    firebaseManager = FirebaseManager();
    authDataSource = AuthDataSourceImpl(firebaseManager);
    authRepository = AuthRepositoryImpl(authDataSource);
    loginUseCase = LoginUseCase(authRepository);
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState('Loading...'));

    try {
      await loginUseCase.invoke(email, password);
      // createUserInDb(user);
      emit(LoginSuccessState());
    } on ServerErrorException catch (e) {
      emit(LoginFailState(e.errorMessage));
    }
  }
}

abstract class LoginViewState {}

class LoginInitialState extends LoginViewState {}

class LoginSuccessState extends LoginViewState {}

class LoginLoadingState extends LoginViewState {
  String loadingMessage;

  LoginLoadingState(this.loadingMessage);
}

class LoginFailState extends LoginViewState {
  String failMessage;

  LoginFailState(this.failMessage);
}
