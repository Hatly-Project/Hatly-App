import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/api/refresh_access_token_response.dart';
import 'package:hatly/data/api/refresh_auth_request.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/main.dart';
import 'package:hatly/utils/dialog_utils.dart';

class Authinterceptor extends Interceptor {
  final Dio dio;

  Authinterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("request ${options.queryParameters}");
    final accessToken =
        await const FlutterSecureStorage().read(key: 'accessToken');
    final refreshToken =
        await const FlutterSecureStorage().read(key: 'refreshToken');

    if (accessToken != null && refreshToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      options.headers['Cookie'] = 'refreshToken=$refreshToken';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var responseHeaders = response.headers.map;

    if (responseHeaders['set-cookie'] != null) {
      var refreshTokenList = responseHeaders['set-cookie']?.first.split(';');

      var refreshToken = refreshTokenList![0].split('=');
      const FlutterSecureStorage()
          .write(key: 'refreshToken', value: refreshToken[1]);
    }
    print("response ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String errorMessage = "";
    if (err.requestOptions.path.contains("auth/refresh")) {
      errorMessage = err.response?.data['message'];
      DialogUtils.showDialogIos(
        statusCode: err.response?.statusCode,
        context: navigatorKey.currentContext!,
        alertMsg: "Fail",
        alertContent: errorMessage,
      );
      return;
    }
    if (err.response?.statusCode == 401) {
      final newTokens = await refreshAccessToken();
      if (newTokens['accessToken'] != null) {
        print("New access token: ${newTokens['accessToken']}");
        err.requestOptions.headers['Authorization'] =
            'Bearer ${newTokens['accessToken']}';
        err.requestOptions.headers['Cookie'] =
            'refreshToken=${newTokens['refreshToken']}';
        if (err.requestOptions.path.contains("auth/check")) {
          err.requestOptions.data = {
            "token": newTokens['accessToken'],
          };
        }
        final retriedRequest = await dio.fetch(err.requestOptions);
        return handler.resolve(retriedRequest);
      }
    } else {
      throw ServerErrorException(
        errorMessage: err.response?.data['message'],
        statusCode: err.response?.statusCode,
      );
    }
  }

  Future<Map<String, String>> refreshAccessToken() async {
    print("Refreshing access token...");
    String? accessToken =
        await const FlutterSecureStorage().read(key: 'accessToken');
    String? refreshToken =
        await const FlutterSecureStorage().read(key: 'refreshToken');

    print("Stored access token before request: $accessToken");

    late Response response;
    // var url = Uri.https(baseUrl, '$apiVersion/auth/refresh');
    var requestBody = RefreshAuthRequest(token: accessToken);
    response = await dio.post(
      'https://hatly-api.onrender.com/api/v2/auth/refresh',
      data: requestBody.toJson(),
    );
    var refreshResponse =
        RefreshAccessTokenResponse.fromJson(jsonEncode(response.data));
    var responseHeaders = response.headers.map;
    var refreshTokenList = responseHeaders['set-cookie']?.first.split(';');

    var refreshedRefreshToken = refreshTokenList![0].split('=');
    print('new refresh token response ${refreshedRefreshToken[1]}');
    print("new access tokeb: ${refreshResponse.accessToken}");

    await const FlutterSecureStorage()
        .write(key: 'refreshToken', value: refreshedRefreshToken[1]);

    await const FlutterSecureStorage()
        .write(key: 'accessToken', value: refreshResponse.accessToken);
    return {
      'accessToken': refreshResponse.accessToken!,
      'refreshToken': refreshedRefreshToken[1]
    };
  }
}
