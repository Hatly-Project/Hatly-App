import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/auth_datasoruce_impl.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/repository/auth_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';
import 'package:hatly/domain/usecase/reset_password_usecase.dart';
import 'package:hatly/domain/usecase/send_reset_email_usecase.dart';
import 'package:hatly/domain/usecase/verify_otp_usecase.dart';

class ForgetPasswrodScreenViewmodel extends Cubit<ForgetPasswordViewState> {
  late ApiManager _apiManager;
  late AuthRepository _authRepository;
  late AuthDataSource _authDataSource;
  late SendResetEmailUsecase _sendResetEmailUsecase;
  late VerifyOtpUsecase _verifyOtpUsecase;
  late ResetPasswordUsecase _resetPasswordUsecase;
  ForgetPasswrodScreenViewmodel() : super(ForgetPasswordInitialState()) {
    _apiManager = ApiManager();
    _authDataSource = AuthDataSourceImpl(_apiManager);
    _authRepository = AuthRepositoryImpl(_authDataSource);
    _sendResetEmailUsecase = SendResetEmailUsecase(_authRepository);
    _verifyOtpUsecase = VerifyOtpUsecase(_authRepository);
    _resetPasswordUsecase = ResetPasswordUsecase(_authRepository);
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

  void verifyOtpCode(String otp) async {
    emit(VerifyCodeLoadingState('Loading...'));

    try {
      var response = await _verifyOtpUsecase.invoke(otp);
      // createUserInDb(user);
      emit(VerifyCodeSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(VerifyCodeFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(VerifyCodeFailState(e.toString()));
    }
  }

  void resetPassword(String otp, String newPassword) async {
    emit(ResetPasswordLoadingState('Loading...'));

    try {
      var response = await _resetPasswordUsecase.invoke(
          otp: otp, newPassword: newPassword);
      // createUserInDb(user);
      emit(ResetPasswordSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(ResetPasswordFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(ResetPasswordFailState(e.toString()));
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

class VerifyCodeSuccessState extends ForgetPasswordViewState {
  SendResetEmailResponseDto responseDto;

  VerifyCodeSuccessState(this.responseDto);
}

class VerifyCodeLoadingState extends ForgetPasswordViewState {
  String loadingMessage;

  VerifyCodeLoadingState(this.loadingMessage);
}

class VerifyCodeFailState extends ForgetPasswordViewState {
  String failMessage;

  VerifyCodeFailState(this.failMessage);
}

class ResetPasswordSuccessState extends ForgetPasswordViewState {
  SendResetEmailResponseDto responseDto;

  ResetPasswordSuccessState(this.responseDto);
}

class ResetPasswordLoadingState extends ForgetPasswordViewState {
  String loadingMessage;

  ResetPasswordLoadingState(this.loadingMessage);
}

class ResetPasswordFailState extends ForgetPasswordViewState {
  String failMessage;

  ResetPasswordFailState(this.failMessage);
}
