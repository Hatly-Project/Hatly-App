import 'dart:ffi';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
import 'package:hatly/data/api/register/register_response/register_response.dart';
import 'package:hatly/data/api/register/register_request.dart';
import 'package:hatly/data/api/shipments/create_shipment_request/create_shipment_request.dart';
import 'package:hatly/data/api/shipments/create_shipment_request/item.dart';
import 'package:hatly/data/api/shipments/create_shipments_response/create_shipments_response.dart';
import 'package:hatly/data/api/shipments/get_shipments_response/get_shipments_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_response/my_shipment_response.dart';
import 'package:hatly/data/api/trips/get_all_trips_response/get_all_trips_response/get_all_trips_response.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'interceptor/LoggingInterceptor.dart';

class ApiManager {
  static const String baseUrl = 'hatly-api.vercel.app';
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
    } on FormatException catch (e) {
      throw ServerErrorException(e.message);
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
    } on FormatException catch (e) {
      throw ServerErrorException(e.message);
    }
  }

  Future<GetShipmentsResponse> getAllShipments({required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'shipment/all');
      var response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      });

      var getResponse = GetShipmentsResponse.fromJson(response.body);
      if (getResponse.status == false) {
        throw ServerErrorException(getResponse.message!);
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    }
  }

  Future<GetAllTripsResponse> getAllTrips({required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'trip/all');
      var response =
          await client.get(url, headers: {'authorization': 'Bearer $token'});
      var getResponse = GetAllTripsResponse.fromJson(response.body);
      print('trip api');

      if (getResponse.status == false) {
        throw ServerErrorException(getResponse.message!);
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    }
  }

  Future<MyShipmentResponse> getUserShipments({required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'user/shipments');
      var response = await client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      var getResponse = MyShipmentResponse.fromJson(response.body);
      print('apiii');

      if (getResponse.status == false) {
        throw ServerErrorException(getResponse.message!);
      }

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    }
  }

  Future<CreateShipmentsResponse> createShipment(
      {String? title,
      String? note,
      String? from,
      String? to,
      String? date,
      double? reward,
      List<Item>? items,
      required String token}) async {
    try {
      print('item api: $note');
      var url = Uri.https(baseUrl, 'shipment/new');
      var requestBody = CreateShipmentRequest(
          title: title,
          from: from,
          to: to,
          note: note,
          expectedDate: date,
          items: items,
          reward: reward);

      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          });
      var shipmentResponse = CreateShipmentsResponse.fromJson(response.body);

      if (shipmentResponse.status == false) {
        throw ServerErrorException(shipmentResponse.message!);
      }
      return shipmentResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on FormatException catch (e) {
      throw ServerErrorException(e.message);
    }
  }
}
