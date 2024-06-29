import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/auth_datasoruce_impl.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/repository/auth_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';
import 'package:hatly/domain/usecase/send_reset_email_usecase.dart';

class ForgetPasswrodScreenViewmodel extends Cubit<ForgetPasswordViewState> {
  late ApiManager _apiManager;
  late AuthRepository _authRepository;
  late AuthDataSource _authDataSource;
  late SendResetEmailUsecase _sendResetEmailUsecase;
  ForgetPasswrodScreenViewmodel() : super(ForgetPasswordInitialState()) {
    _apiManager = ApiManager();
    _authDataSource = AuthDataSourceImpl(_apiManager);
    _authRepository = AuthRepositoryImpl(_authDataSource);
    _sendResetEmailUsecase = SendResetEmailUsecase(_authRepository);
  }

  void sendResetEmail(String email) async {
    emit(ResetEmailLoadingState('Loading...'));

    try {
      var response = await _sendResetEmailUsecase.invoke(email);
      // createUserInDb(user);
      emit(ResetEmailSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(ResetEmailFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(ResetEmailFailState(e.toString()));
    }
  }
}

abstract class ForgetPasswordViewState {}

class ForgetPasswordInitialState extends ForgetPasswordViewState {}

class ResetEmailSuccessState extends ForgetPasswordViewState {
  SendResetEmailResponseDto responseDto;

  ResetEmailSuccessState(this.responseDto);
}

class ResetEmailLoadingState extends ForgetPasswordViewState {
  String loadingMessage;

  ResetEmailLoadingState(this.loadingMessage);
}

class ResetEmailFailState extends ForgetPasswordViewState {
  String failMessage;

  ResetEmailFailState(this.failMessage);
}
