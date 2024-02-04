import 'dart:convert';
import 'dart:ffi';
import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/countries_states/countries.dart';
import 'package:hatly/data/api/countries_states/countries_states.dart';
import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
import 'package:hatly/data/api/register/register_response/register_response.dart';
import 'package:hatly/data/api/register/register_request.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/data/api/shipments/create_shipment_request/create_shipment_request.dart';
import 'package:hatly/data/api/shipments/create_shipments_response/create_shipments_response.dart';
import 'package:hatly/data/api/shipments/get_shipments_response/get_shipments_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_deals_response/my_shipment_deals_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_response/my_shipment_response.dart';
import 'package:hatly/data/api/trip_deal/deals.dart';
import 'package:hatly/data/api/trip_deal/trip_deal_request.dart';
import 'package:hatly/data/api/trip_deal/trip_deal_response.dart';
import 'package:hatly/data/api/trips/create_trip_request/create_trip_request.dart';
import 'package:hatly/data/api/trips/create_trip_response/create_trip_response.dart';
import 'package:hatly/data/api/trips/get_all_trips_response/get_all_trips_response/get_all_trips_response.dart';
import 'package:hatly/data/api/trips/get_user_trip_response/get_user_trip_response.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'interceptor/LoggingInterceptor.dart';

class ApiManager {
  static const String baseUrl = 'hatlyapi.onrender.com';
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
      String? password,
      String? fcmToken}) async {
    try {
      var url = Uri.https(baseUrl, 'user/register');
      var requestBody = RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        image: image,
        password: password,
        fcmToken: fcmToken,
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<Countries> getCountriesFlags() async {
    try {
      var url = Uri.https(baseUrl, 'assets');
      var response = await client.get(url);

      var countriesResponse = Countries.fromJson(response.body);
      return countriesResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<MyShipmentDealsResponse> getMyShipmentDeals(
      {required String token, required int shipmentId}) async {
    try {
      var url = Uri.https(
          baseUrl, 'shipment/deals', {'shipmentId': shipmentId.toString()});
      var response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      });

      var getResponse = MyShipmentDealsResponse.fromJson(response.body);
      if (getResponse.status == false) {
        throw ServerErrorException(getResponse.message!);
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<GetUserTripResponse> getUserTrips({required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'user/trips');
      var response = await client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      var getResponse = GetUserTripResponse.fromJson(response.body);

      if (getResponse.status == false) {
        throw ServerErrorException(getResponse.message!);
      }

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<TripDealResponse> sendTripDeal(
      {int? shipmentId,
      double? reward,
      required String token,
      required int tripId}) async {
    try {
      var url = Uri.https(baseUrl, 'deal/trip', {
        'tripId': tripId.toString(),
      });
      var requestBody =
          TripDealRequest(deals: Deals(shipmentId: shipmentId, reward: reward));
      print(url.toString());
      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          });

      var tripDealResponse = TripDealResponse.fromJson(response.body);
      if (tripDealResponse.status == false) {
        throw ServerErrorException(tripDealResponse.message!);
      }
      return tripDealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

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
      required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'trip/new');
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
          departData: departDate);
      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          });

      var tripResponse = CreateTripResponse.fromJson(response.body);
      if (tripResponse.status == false) {
        throw ServerErrorException(tripResponse.message!);
      }
      return tripResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

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
      required String token}) async {
    try {
      print('item api: $note');
      var url = Uri.https(baseUrl, 'shipment/new');
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
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }
}
