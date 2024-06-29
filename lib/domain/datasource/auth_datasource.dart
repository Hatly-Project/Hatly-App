import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';

import '../models/register_response_dto.dart';

abstract class AuthDataSource {
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
      required String? fcmToken});
  Future<LoginResponseDto> login(String email, String password);

  Future<MyShipmentDealsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId});

  Future<LoginResponseDto> loginWithGoogle(String idToken);

  Future<SendResetEmailResponseDto> sendResetEmail(String email);
}
