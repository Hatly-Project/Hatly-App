import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
import 'package:hatly/data/api/register/register_response/register_response.dart';
import 'package:hatly/data/api/register/register_request.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'interceptor/LoggingInterceptor.dart';

class ApiManager {
  static const String baseUrl = 'hatly.vercel.app';
  Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );

  Future<RegisterResponse> registerUser(
      {String? name,
      String? email,
      String? phone,
      String? image,
      String? password}) async {
    try {
      var url = Uri.https(baseUrl, 'user/register');
      var requestBody = RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        image: image,
        password: password,
      );
      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {'content-type': 'application/json'});
      var registerResponse = RegisterResponse.fromJson(response.body);

      if (registerResponse.status == false) {
        throw ServerErrorException(registerResponse.message!);
      }
      return registerResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      var url = Uri.https(baseUrl, 'user/login');
      var requestBody = LoginRequest(
        email: email,
        password: password,
      );
      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {'content-type': 'application/json'});
      var loginResponse = LoginResponse.fromJson(response.body);

      if (loginResponse.status == false) {
        print('error ${loginResponse.message}');
        throw ServerErrorException(loginResponse.message!);
      }
      return loginResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    }
  }
}
