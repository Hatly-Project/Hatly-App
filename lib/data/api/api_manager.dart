import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/check_access_token_response.dart';
import 'package:hatly/data/api/check_acess_token.dart';
import 'package:hatly/data/api/counter_offer.dart';
import 'package:hatly/data/api/countries_states/countries_states.dart';
import 'package:hatly/data/api/get_trip_deal_details/get_trip_deal_details.dart';
import 'package:hatly/data/api/interceptor/AuthInterceptor.dart';
import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
import 'package:hatly/data/api/refresh_token_request.dart';
import 'package:hatly/data/api/refresh_token_response.dart';
import 'package:hatly/data/api/register/register_response/register_response.dart';
import 'package:hatly/data/api/register/register_request.dart';
import 'package:hatly/data/api/send_reset_email_request.dart';
import 'package:hatly/data/api/send_reset_email_response.dart';
import 'package:hatly/data/api/shipment_matching_trips_response/shipment_matching_trips_response.dart';
import 'package:hatly/data/api/shipments/accept_reject_shipment_deal_response/accept_reject_shipment_deal_response.dart';
import 'package:hatly/data/api/shipments/create_shipment_request/create_shipment_request.dart';
import 'package:hatly/data/api/shipments/create_shipments_response/create_shipments_response.dart';
import 'package:hatly/data/api/shipments/get_shipment_deal_details/get_shipment_deal_details.dart';
import 'package:hatly/data/api/shipments/get_shipments_response/get_shipments_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_deals_response/my_shipment_deals_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_response/my_shipment_response.dart';
import 'package:hatly/data/api/sign_in_google_request.dart';
import 'package:hatly/data/api/deals/deal_request.dart';
import 'package:hatly/data/api/deals/deal_response.dart';
import 'package:hatly/data/api/trip_matching_shipments_response/trip_matching_shipments_response.dart';
import 'package:hatly/data/api/trips/create_trip_request/create_trip_request.dart';
import 'package:hatly/data/api/trips/create_trip_response/create_trip_response.dart';
import 'package:hatly/data/api/trips/get_all_trips_response/get_all_trips_response/get_all_trips_response.dart';
import 'package:hatly/data/api/trips/get_user_trip_response/get_user_trip_response.dart';
import 'package:hatly/data/api/trips/my_trip_deals_response/my_trip_deals_response.dart';
import 'package:hatly/data/api/update_payment_info_request.dart';
import 'package:hatly/data/api/update_payment_info_response.dart';
import 'package:hatly/data/api/update_profile_request.dart';
import 'package:hatly/data/api/verify_otp_request.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/providers/access_token_provider.dart';

class ApiManager {
  static const String baseUrl = 'https://hatly-api.onrender.com';
  static const String apiVersion = '/api/v2';
  final AccessTokenProvider? accessTokenProvider;
  late Dio dio;
  factory ApiManager({AccessTokenProvider? accessTokenProvider}) {
    return ApiManager._internal(accessTokenProvider);
  }
  ApiManager._internal(this.accessTokenProvider) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'content-type': 'application/json',
      },
    ));
    dio.interceptors.add(Authinterceptor(dio));
  }
  // Client client = InterceptedClient.build(
  //   interceptors: [
  //     LoggingInterceptor(),
  //   ],
  // );

  //  ApiManager({this.accessTokenProvider});

  Future<RegisterResponse> registerUser(
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
    late Response response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/auth/register');
      var requestBody = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        // phone: '+$phone',
        password: password,
        fcmToken: fcmToken,
        // dob: '2000-02-02',
        // address: 'London',
        // city: 'London',
        // country: 'GB',
        // postalCode: 'SO15',
        // ip: ip,
      );
      response = await dio.post('$apiVersion/auth/register',
          data: requestBody.toJson());
      var registerResponse =
          RegisterResponse.fromJson(jsonEncode(response.data));

      return registerResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<CountriesStates> getCountriesFlags() async {
    Response? response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/assets', {
      //   'withStates': 'true',
      // });
      response = await dio.get('$apiVersion/assets', queryParameters: {
        'withStates': 'true',
      });
      var countriesResponse =
          CountriesStates.fromJson(jsonEncode(response.data));

      return countriesResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage,
          statusCode: response?.statusCode ?? 500);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response?.statusCode ?? 500);
    }
  }

  Future<UpdatePaymentInfoResponse> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      String? accountCurrency,
      int? userId,
      String? accountCountry}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'payments/add-bank-account', {
      //   'userId': userId.toString(),
      // });
      var requestBody = UpdatePaymentInfoRequest(
        accountNumber: accountNumber,
        accountName: accountName,
        accountCountry: accountCountry,
        accountCurrency: accountCurrency,
        routingNumber: routingNumber,
      );
      response = await dio.post(
        '$apiVersion/payment/info',
        data: requestBody.toJson(),
      );

      var updateProfileResponse =
          UpdatePaymentInfoResponse.fromJson(jsonEncode(response.data));

      return updateProfileResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<UpdatePaymentInfoResponse> updateProfileWithCheckAccessToken(
  //     {String? dob,
  //     String? address,
  //     String? city,
  //     String? country,
  //     String? postalCode,
  //     String? ip,
  //     required String? accessToken,
  //     String? phone}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await updateProfile(
  //         accessToken: accessToken,
  //         dob: dob,
  //         address: address,
  //         city: city,
  //         country: country,
  //         postalCode: postalCode,
  //         ip: ip,
  //         phone: phone,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await updateProfile(
  //         accessToken: newAccessToken,
  //         dob: dob,
  //         address: address,
  //         city: city,
  //         country: country,
  //         postalCode: postalCode,
  //         ip: ip,
  //         phone: phone,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.errorMessage, statusCode: e.statusCode);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<UpdatePaymentInfoResponse> updateProfile(
      {String? dob,
      String? address,
      String? city,
      String? country,
      String? postalCode,
      String? ip,
      required String? accessToken,
      String? phone}) async {
    late Response response;
    try {
      print(
          'dob $dob , address $address , city $city , country $country , postal $postalCode , ip $ip , phone $phone');
      // var url = Uri.https(baseUrl, 'users');
      var requestBody = UpdateProfileRequest(
        dob: dob,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        ip: ip,
        phone: phone,
      );
      print('request body : ${requestBody.toJson()}');
      // response = await client.patch(url, body: requestBody.toJson(), headers: {
      //   'content-type': 'application/json',
      //   'authorization': 'Bearer $accessToken',
      // });
      response = await dio.patch(
        '$apiVersion/users',
        data: requestBody.toJson(),
        options: Options(
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $accessToken',
          },
        ),
      );

      var updateProfileResponse =
          UpdatePaymentInfoResponse.fromJson(jsonEncode(response.data));

      return updateProfileResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/auth/login');
      var requestBody = LoginRequest(
        email: email,
        password: password,
      );
      response = await dio.post(
        '$apiVersion/auth/login',
        data: requestBody.toJson(),
      );
      // response = await client.post(url,
      //     body: requestBody.toJson(),
      //     headers: {'content-type': 'application/json'});
      var verifyResponse = LoginResponse.fromJson(jsonEncode(response.data));

      return verifyResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<SendResetEmailResponse> sendResetEmail(String email) async {
    late Response response;
    try {
      var requestBody = SendResetEmailRequest(
        email: email,
        ar: false,
      );
      response = await dio.post(
        '$apiVersion/auth/reset/password',
        data: requestBody.toJson(),
      );
      var verifyResponse =
          SendResetEmailResponse.fromJson(jsonEncode(response.data));

      return verifyResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<SendResetEmailResponse> verifyOtp(String otp) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/auth/check/otp');
      var requestBody = VerifyOtpRequest(
        otp: otp,
      );
      response = await dio.post(
        '$apiVersion/auth/check/otp',
        data: requestBody.toJson(),
      );
      var verifyResponse =
          SendResetEmailResponse.fromJson(jsonEncode(response.data));

      return verifyResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<SendResetEmailResponse> resetPassword(
  //     {String? otp, String? newPassword}) async {
  //   late Response response;
  //   try {
  //     var url = Uri.https(baseUrl, '$apiVersion/auth/check/otp');
  //     var requestBody = VerifyOtpRequest(
  //       otp: otp,
  //     );
  //     response = await client.post(url,
  //         body: requestBody.toJson(),
  //         headers: {'content-type': 'application/json'});
  //     var verifyResponse = SendResetEmailResponse.fromJson(jsonEncode(response.data));
  //     if (verifyResponse.status == false) {
  //       print('error ${verifyResponse.message}');
  //       throw ServerErrorException(
  //           errorMessage: verifyResponse.message!,
  //           statusCode: response.statusCode);
  //     }
  //     return verifyResponse;
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.errorMessage, statusCode: response.statusCode);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.toString(), statusCode: response.statusCode);
  //   }
  // }

  Future<LoginResponse> loginWithGoogle(String idToken) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/auth/google');
      var requestBody = SignInGoogleRequest(
        idToken: idToken,
      );
      response = await dio.post(
        '$apiVersion/auth/google',
        data: requestBody.toJson(),
      );
      var verifyResponse = LoginResponse.fromJson(jsonEncode(response.data));

      return verifyResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<String> refreshAccessToken() async {
  //   String? refreshToken =
  //       await const FlutterSecureStorage().read(key: 'refreshToken');
  //   String? accessToken =
  //       await const FlutterSecureStorage().read(key: 'accessToken');

  //   late Response response;
  //   try {
  //     // var url = Uri.https(baseUrl, '$apiVersion/auth/refresh');
  //     var requestBody = RefreshAuthRequest(token: accessToken);
  //     response = await dio.post('$apiVersion/auth/refresh',
  //         data: requestBody.toJson(),
  //         options: Options(
  //           headers: {'Cookie': 'refreshToken=$refreshToken'},
  //         ));
  //     var refreshResponse =
  //         RefreshAccessTokenResponse.fromJson(jsonEncode(response.data));
  //     if (refreshResponse.status == true) {
  //       var responseHeaders = response.headers.map;
  //       var refreshTokenList = responseHeaders['set-cookie']?.first.split(';');

  //       var refreshedRefreshToken = refreshTokenList![0].split('=');
  //       print('new refresh token response ${refreshedRefreshToken[1]}');
  //       await const FlutterSecureStorage()
  //           .write(key: 'refreshToken', value: refreshedRefreshToken[1]);
  //       accessTokenProvider?.setRefreshToken(refreshedRefreshToken[1]);
  //     } else {
  //       print('error ${response.statusCode}');
  //       throw ServerErrorException(
  //           errorMessage: refreshResponse.message!,
  //           statusCode: response.statusCode);
  //     }
  //     // await const FlutterSecureStorage()
  //     //     .write(key: 'accessToken', value: refreshResponse.accessToken);
  //     accessTokenProvider?.setAccessToken(refreshResponse.accessToken!);
  //     return refreshResponse.accessToken!;
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.errorMessage, statusCode: response.statusCode);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.toString(), statusCode: response.statusCode);
  //   }
  // }

  Future<bool> chechAccessTokenExpired() async {
    String? accessToken =
        await const FlutterSecureStorage().read(key: 'accessToken');

    String? refreshToken =
        await const FlutterSecureStorage().read(key: 'refreshToken');

    // var url = Uri.https(baseUrl, '$apiVersion/auth/check');
    var requestBody =
        CheckAcessTokenRequest(token: accessToken, refreshToken: refreshToken);
    print("requestBody ${requestBody.toJson()}");
    Response response = await dio.post(
      '$apiVersion/auth/check',
      data: requestBody.toJson(),
    );
    print("response ${response.data}");
    var checkResponse =
        CheckAccessTokenResponse.fromJson(jsonEncode(response.data));

    return checkResponse.status!;
  }

  // Future<GetShipmentsResponse> getAllShipmentsWithCheckAccessToken({
  //   required String accessToken,
  //   int page = 1,
  //   String? beforeExpectedDate,
  //   String? afterExpectedDate,
  //   String? from,
  //   String? fromCity,
  //   String? to,
  //   String? toCity,
  //   bool? latest,
  // }) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getAllShipments(
  //         accessToken: accessToken,
  //         page: page,
  //         beforeExpectedDate: beforeExpectedDate,
  //         afterExpectedDate: afterExpectedDate,
  //         from: from,
  //         fromCity: fromCity,
  //         to: to,
  //         toCity: toCity,
  //         latest: latest,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getAllShipments(
  //         accessToken: newAccessToken,
  //         page: page,
  //         beforeExpectedDate: beforeExpectedDate,
  //         afterExpectedDate: afterExpectedDate,
  //         from: from,
  //         fromCity: fromCity,
  //         to: to,
  //         toCity: toCity,
  //         latest: latest,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(
  //         errorMessage: e.errorMessage, statusCode: e.statusCode);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<GetShipmentsResponse> getAllShipments({
    required String accessToken,
    int page = 1,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) async {
    late Response response;

    try {
      // var url = Uri.https(baseUrl, '$apiVersion/shipment', {
      //   'page': page.toString(),
      //   'take': 4.toString(),
      //   if (beforeExpectedDate != null)
      //     'beforeExpectedDate': beforeExpectedDate,
      //   if (afterExpectedDate != null) 'afterExpectedDate': afterExpectedDate,
      //   if (from != null) 'from': from,
      //   if (fromCity != null) 'fromCity': fromCity,
      //   if (to != null) 'to': to,
      //   if (toCity != null) 'toCity': toCity,
      //   if (latest != null) 'latest': latest,
      // });
      response = await dio.get("$apiVersion/shipment", queryParameters: {
        'page': page.toString(),
        'take': 4.toString(),
        if (beforeExpectedDate != null)
          'beforeExpectedDate': beforeExpectedDate,
        if (afterExpectedDate != null) 'afterExpectedDate': afterExpectedDate,
        if (from != null) 'from': from,
        if (fromCity != null) 'fromCity': fromCity,
        if (to != null) 'to': to,
        if (toCity != null) 'toCity': toCity,
        if (latest != null) 'latest': latest,
      });

      var getResponse =
          GetShipmentsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // if (response.statusCode == 401) {
  //         print('token -------------- expired -------------');
  //         String newAccessToken = await refreshAccessToken();

  //         getAllShipments(accessToken: newAccessToken, page: page);
  //       }

  // Future<MyShipmentDealsResponse> getMyShipmentDealsWithCheckAccessToken(
  //     {required String accessToken, required int shipmentId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getMyShipmentDeals(
  //           accessToken: accessToken, shipmentId: shipmentId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getMyShipmentDeals(
  //           accessToken: newAccessToken, shipmentId: shipmentId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<MyShipmentDealsResponse> getMyShipmentDeals(
      {required String accessToken, required int shipmentId}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'shipments/${shipmentId.toString()}/deals');
      response = await dio.get(
        "$apiVersion/shipments/${shipmentId.toString()}/deals",
      );

      var getResponse =
          MyShipmentDealsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<MyTripDealsResponse> getMyTripDeals(
      {required String accessToken, required int tripId}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'trips/${tripId.toString()}/deals');
      response = await dio.get(
        "$apiVersion/trips/${tripId.toString()}/deals",
      );

      var getResponse = MyTripDealsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<MyTripDealsResponse> getMyTripDealsWithCheckAccessToken(
  //     {required String accessToken, required int tripId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getMyTripDeals(accessToken: accessToken, tripId: tripId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getMyTripDeals(
  //           accessToken: newAccessToken, tripId: tripId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  // Future<ShipmentMatchingTripsResponse>
  //     getShipmentMatchingTripsWithCheckAccessToken(
  //         {required String accessToken, int? shipmentId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getShipmentMatchingTrips(
  //           accessToken: accessToken, shipmentId: shipmentId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getShipmentMatchingTrips(
  //           accessToken: newAccessToken, shipmentId: shipmentId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<ShipmentMatchingTripsResponse> getShipmentMatchingTrips(
      {required String accessToken, required int shipmentId}) async {
    late Response response;
    try {
      // var url = Uri.https(
      //     baseUrl, 'shipments/${shipmentId.toString()}/matching-trips');
      response = await dio.get(
        "$apiVersion/shipments/${shipmentId.toString()}/matching-trips",
      );

      var getResponse = ShipmentMatchingTripsResponse.fromJson(
          jsonEncode(jsonEncode(response.data)));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<TripMatchingShipmentsResponse>
  //     getTripsMatchingShipmentsWithCheckAccessToken(
  //         {required String accessToken, required int tripId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getTripsMatchingShipments(
  //           accessToken: accessToken, tripId: tripId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getTripsMatchingShipments(
  //           accessToken: newAccessToken, tripId: tripId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<TripMatchingShipmentsResponse> getTripsMatchingShipments(
      {required String accessToken, required int tripId}) async {
    late Response response;
    try {
      // var url =
      //     Uri.https(baseUrl, 'trips/${tripId.toString()}/matching-shipments');
      response = await dio.get(
        "$apiVersion/trips/${tripId.toString()}/matching-shipments",
      );

      var getResponse =
          TripMatchingShipmentsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<GetMyShipmentDealDetailsResponse>
  //     getMyShipmentDealDetailsWithCheckAccessToken(
  //         {required String accessToken, required String dealId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getMyShipmentDealDetails(
  //           accessToken: accessToken, dealId: dealId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getMyShipmentDealDetails(
  //           accessToken: newAccessToken, dealId: dealId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<GetMyShipmentDealDetailsResponse> getMyShipmentDealDetails(
      {required String accessToken, required String dealId}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/${dealId.toString()}');
      response = await dio.get(
        "$apiVersion/deals/${dealId.toString()}",
      );

      var getResponse =
          GetMyShipmentDealDetailsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<GetTripDealDetailsResponse> getMyTripDealDetailsWithCheckAccessToken(
  //     {required String accessToken, required String dealId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getMyTripDealDetails(
  //           accessToken: accessToken, dealId: dealId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getMyTripDealDetails(
  //           accessToken: newAccessToken, dealId: dealId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<GetTripDealDetailsResponse> getMyTripDealDetails(
      {required String accessToken, required String dealId}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/${dealId.toString()}');
      response = await dio.get(
        "$apiVersion/deals/${dealId.toString()}",
      );

      var getResponse =
          GetTripDealDetailsResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<AcceptOrRejectShipmentDealResponse>
  //     changeShipmentDealStatusWithCheckAccessToken(
  //         {required String accessToken,
  //         required String dealId,
  //         required String dealType,
  //         required String status}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await changeShipmentDealStatus(
  //           accessToken: accessToken,
  //           dealId: dealId,
  //           status: status,
  //           dealType: dealType);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await changeShipmentDealStatus(
  //           accessToken: newAccessToken,
  //           dealId: dealId,
  //           status: status,
  //           dealType: dealType);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<AcceptOrRejectShipmentDealResponse> changeShipmentDealStatus(
      {required String accessToken,
      required String dealId,
      required String dealType,
      required String status}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/$dealType', {
      //   'status': status,
      // });
      response = await dio.post(
        "$apiVersion/deals/${dealId.toString()}/$dealType",
        queryParameters: {'status': status},
      );

      var getResponse = AcceptOrRejectShipmentDealResponse.fromJson(
          jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<GetAllTripsResponse> getAllTripsWithCheckAccessToken(
  //     {required String accessToken,
  //     String? beforeExpectedDate,
  //     String? afterExpectedDate,
  //     String? from,
  //     String? fromCity,
  //     String? to,
  //     bool? latest,
  //     String? toCity,
  //     int page = 1}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getAllTrips(
  //         accessToken: accessToken,
  //         page: page,
  //         beforeExpectedDate: beforeExpectedDate,
  //         afterExpectedDate: afterExpectedDate,
  //         from: from,
  //         fromCity: fromCity,
  //         latest: latest,
  //         to: to,
  //         toCity: toCity,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getAllTrips(
  //         accessToken: newAccessToken,
  //         page: page,
  //         beforeExpectedDate: beforeExpectedDate,
  //         afterExpectedDate: afterExpectedDate,
  //         from: from,
  //         fromCity: fromCity,
  //         to: to,
  //         toCity: toCity,
  //         latest: latest,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<GetAllTripsResponse> getAllTrips(
      {required String accessToken,
      String? beforeExpectedDate,
      String? afterExpectedDate,
      String? from,
      String? fromCity,
      String? to,
      String? toCity,
      bool? latest,
      int page = 1}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, '$apiVersion/trip', {
      //   'page': page.toString(),
      //   'take': 4.toString(),
      //   if (beforeExpectedDate != null)
      //     'beforeExpectedDate': beforeExpectedDate,
      //   if (afterExpectedDate != null) 'afterExpectedDate': afterExpectedDate,
      //   if (from != null) 'from': from,
      //   if (fromCity != null) 'fromCity': fromCity,
      //   if (to != null) 'to': to,
      //   if (toCity != null) 'toCity': toCity,
      //   if (latest != null) 'latest': latest,
      // });
      response = await dio.get("$apiVersion/trip", queryParameters: {
        'page': page.toString(),
        'take': 4.toString(),
        if (beforeExpectedDate != null)
          'beforeExpectedDate': beforeExpectedDate,
        if (afterExpectedDate != null) 'afterExpectedDate': afterExpectedDate,
        if (from != null) 'from': from,
        if (fromCity != null) 'fromCity': fromCity,
        if (to != null) 'to': to,
        if (toCity != null) 'toCity': toCity,
        if (latest != null) 'latest': latest,
      });

      var getResponse = GetAllTripsResponse.fromJson(jsonEncode(response.data));
      print('trip api');

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<MyShipmentResponse> getUserShipments(
      {required String accessToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'users/shipments');
      response = await dio.get(
        '$apiVersion/user/shipments',
      );

      var getResponse = MyShipmentResponse.fromJson(jsonEncode(response.data));
      print('apiii');

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<MyShipmentResponse> getMyShipmentsWithCheckAccessToken(
  //     {required String accessToken}) async {
  //   print("getMyShipmentsWithCheckAccessToken");
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getUserShipments(accessToken: accessToken);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getUserShipments(accessToken: newAccessToken);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  // Future<GetUserTripResponse> getUserTripsWithCheckAccessToken({
  //   required String accessToken,
  // }) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await getUserTrips(
  //         accessToken: accessToken,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await getUserTrips(
  //         accessToken: newAccessToken,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<GetUserTripResponse> getUserTrips(
      {required String accessToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'users/trips');
      response = await dio.get(
        '$apiVersion/user/trips',
      );

      var getResponse = GetUserTripResponse.fromJson(jsonEncode(response.data));

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<DealResponse> sendDealWithCheckAccessToken(
  //     {required String? shipmentId,
  //     String? type,
  //     double? reward,
  //     required String accessToken,
  //     required String tripId}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await sendDeal(
  //           type: type,
  //           accessToken: accessToken,
  //           shipmentId: shipmentId,
  //           reward: reward,
  //           tripId: tripId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await sendDeal(
  //           type: type,
  //           accessToken: accessToken,
  //           shipmentId: shipmentId,
  //           reward: reward,
  //           tripId: tripId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<DealResponse> sendDeal(
      {required String? shipmentId,
      String? type,
      double? reward,
      required String accessToken,
      required String tripId}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/trip', {
      //   'tripId': tripId.toString(),
      // });
      var requestBody = DealRequest(
          tripId: tripId,
          shipmentId: shipmentId,
          reward: reward,
          hatlyFees: 2.5,
          paymentFees: 2.3);

      response = await dio.post(
        '$apiVersion/deal',
        queryParameters: {
          "sendTo": type,
        },
        data: requestBody.toJson(),
      );
      var dealResponse = DealResponse.fromJson(jsonEncode(response.data));

      return dealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<CreateTripResponse> createTripWithCheckAccessToken(
  //     {String? origin,
  //     String? destination,
  //     String? originCity,
  //     String? destinationCity,
  //     int? available,
  //     String? note,
  //     String? addressMeeting,
  //     String? departDate,
  //     BookInfo? bookInfo,
  //     String? notNeed,
  //     List<ItemsNotAllowed>? itemsNotAllowed,
  //     required String accessToken}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await createTrip(
  //         accessToken: accessToken,
  //         itemsNotAllowed: itemsNotAllowed,
  //         notNeed: notNeed,
  //         bookInfo: bookInfo,
  //         departDate: departDate,
  //         addressMeeting: addressMeeting,
  //         note: note,
  //         available: available,
  //         destinationCity: destinationCity,
  //         destination: destination,
  //         origin: origin,
  //         originCity: originCity,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await createTrip(
  //         accessToken: newAccessToken,
  //         itemsNotAllowed: itemsNotAllowed,
  //         notNeed: notNeed,
  //         bookInfo: bookInfo,
  //         departDate: departDate,
  //         addressMeeting: addressMeeting,
  //         note: note,
  //         available: available,
  //         destinationCity: destinationCity,
  //         destination: destination,
  //         origin: origin,
  //         originCity: originCity,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<CreateTripResponse> createTrip(
      {String? origin,
      String? destination,
      String? originCity,
      String? destinationCity,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfo? bookInfo,
      String? notNeed,
      List<ItemsNotAllowed>? itemsNotAllowed,
      required String accessToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'trips');
      var requestBody = CreateTripRequest(
          origin: origin,
          destination: destination,
          originCity: originCity,
          destinationCity: destinationCity,
          available: available,
          bookInfo: bookInfo,
          itemsNotAllowed: itemsNotAllowed,
          note: note,
          addressMeeting: addressMeeting,
          departDate: departDate);
      response = await dio.post(
        '$apiVersion/trip',
        data: requestBody.toJson(),
      );

      var tripResponse = CreateTripResponse.fromJson(jsonEncode(response.data));

      return tripResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<RefreshTokenResponse> refreshFCMTokenWithCheckAccessToken(
  //     {required String accessToken, required String fcmToken}) async {
  //   print('refresh tokeeennn $fcmToken');
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await refreshFCMToken(
  //           accessToken: accessToken, fcmToken: fcmToken);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await refreshFCMToken(
  //           accessToken: newAccessToken, fcmToken: fcmToken);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<RefreshTokenResponse> refreshFCMToken(
      {required String accessToken, required String fcmToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'user/fcm');
      var requestBody = RefreshTokenRequest(fcmToken: fcmToken);
      response = await dio.patch(
        '$apiVersion/user/fcm',
        data: requestBody.toJson(),
      );
      var refreshTokenResponse =
          RefreshTokenResponse.fromJson(jsonEncode(response.data));

      return refreshTokenResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<CounterOfferResponse> makeCounterOfferWithCheckAccessToken(
  //     {required int dealId,
  //     required double reward,
  //     required String accessToken}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await makeCounterOffer(
  //           accessToken: accessToken, reward: reward, dealId: dealId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await makeCounterOffer(
  //           accessToken: newAccessToken, reward: reward, dealId: dealId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<CounterOfferResponse> makeCounterOffer(
      {required int dealId,
      required double reward,
      required String accessToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/counter-offer', {
      //   'reward': reward,
      // });
      response = await dio.patch(
        '$apiVersion/deal/${dealId.toString()}/offer',
        data: {'offer': reward},
      );

      var counterOfferResponse =
          CounterOfferResponse.fromJson(jsonEncode(response.data));

      return counterOfferResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<AcceptOrRejectShipmentDealResponse>
  //     changeDealStatusWithCheckAccessToken(
  //         {required String dealId,
  //         required String status,
  //         required String accessToken}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await changeDealStatus(
  //           accessToken: accessToken, status: status, dealId: dealId);
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await changeDealStatus(
  //           accessToken: accessToken, status: status, dealId: dealId);
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<AcceptOrRejectShipmentDealResponse> changeDealStatus(
      {required String dealId,
      required String status,
      required String accessToken}) async {
    late Response response;
    try {
      // var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/cancel');
      response = await dio.patch(
        '$apiVersion/deal/$dealId',
        queryParameters: {
          'status': status,
        },
      );
      var cancelDealResponse = AcceptOrRejectShipmentDealResponse.fromJson(
          jsonEncode(response.data));

      return cancelDealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  // Future<CreateShipmentsResponse> createShipmentWithCheckAccessToken(
  //     {String? title,
  //     String? note,
  //     String? from,
  //     String? fromCity,
  //     String? toCity,
  //     String? to,
  //     String? date,
  //     double? reward,
  //     List<Item>? items,
  //     required String accessToken}) async {
  //   try {
  //     if (await chechAccessTokenExpired()) {
  //       return await createShipment(
  //         accessToken: accessToken,
  //         title: title,
  //         note: note,
  //         from: from,
  //         fromCity: fromCity,
  //         to: to,
  //         toCity: toCity,
  //         date: date,
  //         reward: reward,
  //         items: items,
  //       );
  //     } else {
  //       var newAccessToken = await refreshAccessToken();
  //       return await createShipment(
  //         accessToken: newAccessToken,
  //         title: title,
  //         note: note,
  //         from: from,
  //         fromCity: fromCity,
  //         to: to,
  //         toCity: toCity,
  //         date: date,
  //         reward: reward,
  //         items: items,
  //       );
  //     }
  //   } on ServerErrorException catch (e) {
  //     throw ServerErrorException(errorMessage: e.errorMessage);
  //   } on Exception catch (e) {
  //     throw ServerErrorException(errorMessage: e.toString());
  //   }
  // }

  Future<CreateShipmentsResponse> createShipment(
      {String? title,
      String? note,
      String? from,
      String? fromCity,
      String? toCity,
      String? to,
      String? date,
      double? reward,
      List<Item>? items,
      required String accessToken}) async {
    late Response response;
    try {
      print('item api: $note');
      // var url = Uri.https(baseUrl, 'shipments');
      var requestBody = CreateShipmentRequest(
          title: title,
          from: from,
          fromCity: fromCity,
          toCity: toCity,
          to: to,
          note: note,
          expectedDate: date,
          items: items,
          reward: reward);

      response = await dio.post(
        '$apiVersion/shipment',
        data: requestBody.toJson(),
      );
      var shipmentResponse =
          CreateShipmentsResponse.fromJson(jsonEncode(response.data));

      return shipmentResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on FormatException catch (e) {
      throw ServerErrorException(
          errorMessage: e.message, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }
}
