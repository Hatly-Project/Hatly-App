import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/auth_datasoruce_impl.dart';
import 'package:hatly/data/firebase/firebase_manager.dart';
import 'package:hatly/data/repository/auth_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/repository/auth_repository.dart';
import 'package:hatly/domain/usecase/register_usecase.dart';

import '../../domain/models/user_model.dart';

class RegisterViewModel extends Cubit<RegisterViewState> {
  late FirebaseManager firebaseManager;
  late AuthRepository authRepository;
  late AuthDataSource authDataSource;
  late RegisterUseCase registerUseCase;
  RegisterViewModel() : super(RegisterInitialState()) {
    firebaseManager = FirebaseManager();
    authDataSource = AuthDataSourceImpl(firebaseManager);
    authRepository = AuthRepositoryImpl(authDataSource);
    registerUseCase = RegisterUseCase(authRepository);
  }

  Future<void> register(String email, String password) async {
    emit(RegisterLoadingState('Loading...'));

    try {
      await registerUseCase.invoke(email, password);
      // createUserInDb(user);
      emit(RegisterSuccessState());
    } on ServerErrorException catch (e) {
      emit(RegisterFailState(e.errorMessage));
    }
  }

  void createUserInDb(User user) async {
    var database = FirebaseFirestore.instance;

    final docRef = database
        .collection('users')
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (user, options) => user.toFirestore(),
        )
        .doc(user.email);

    await docRef.set(user);
  }
}

abstract class RegisterViewState {}

class RegisterInitialState extends RegisterViewState {}

class RegisterSuccessState extends RegisterViewState {}

class RegisterLoadingState extends RegisterViewState {
  String loadingMessage;

  RegisterLoadingState(this.loadingMessage);
}

class RegisterFailState extends RegisterViewState {
  String failMessage;

  RegisterFailState(this.failMessage);
}
