import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/register_response_dto.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';

import '../api/api_manager.dart';

class AuthDataSourceImpl implements AuthDataSource {
  ApiManager apiManager;

  AuthDataSourceImpl(this.apiManager);

  @override
  Future<RegisterResponseDto> register(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? dob,
      String? address,
      String? city,
      String? country,
      String? phone,
      String? postalCode,
      String? ip,
      required String? fcmToken}) async {
    var response = await apiManager.registerUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      ip: ip,
      password: password,
      fcmToken: fcmToken,
    );

    return response.toRegisterDto();
  }

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    var response = await apiManager.loginUser(email, password);

    return response.toLoginDto();
  }

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) {
    // TODO: implement getMyShipmentDealDetails
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseDto> loginWithGoogle(String idToken) async {
    var response = await apiManager.loginWithGoogle(idToken);

    return response.toLoginDto();
  }

  @override
  Future<SendResetEmailResponseDto> sendResetEmail(String email) async {
    var response = await apiManager.sendResetEmail(email);

    return response.toDto();
  }

  @override
  Future<SendResetEmailResponseDto> verifyOtp(String otp) async {
    var response = await apiManager.verifyOtp(otp);

    return response.toDto();
  }

  @override
  Future<SendResetEmailResponseDto> resetPassword(
      String otp, String newPassword) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  // @override
  // Future<SendResetEmailResponseDto> resetPassword(
  //     String otp, String newPassword) async {
  //   var response =
  //       await apiManager.resetPassword(otp: otp, newPassword: newPassword);

  //   return response.toDto();
  // }
}
