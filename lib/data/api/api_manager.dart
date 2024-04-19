import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/cancel_deal_response.dart';
import 'package:hatly/data/api/check_access_token_response.dart';
import 'package:hatly/data/api/check_acess_token.dart';
import 'package:hatly/data/api/counter_offer.dart';
import 'package:hatly/data/api/countries_states/countries.dart';
import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
import 'package:hatly/data/api/refresh_access_token_response.dart';
import 'package:hatly/data/api/refresh_token_request.dart';
import 'package:hatly/data/api/refresh_token_response.dart';
import 'package:hatly/data/api/register/register_response/register_response.dart';
import 'package:hatly/data/api/register/register_request.dart';
import 'package:hatly/data/api/shipment_deal/shipment_deal_request.dart';
import 'package:hatly/data/api/shipment_deal/shipment_deal_response.dart';
import 'package:hatly/data/api/shipments/accept_reject_shipment_deal_response/accept_reject_shipment_deal_response.dart';
import 'package:hatly/data/api/shipments/create_shipment_request/create_shipment_request.dart';
import 'package:hatly/data/api/shipments/create_shipments_response/create_shipments_response.dart';
import 'package:hatly/data/api/shipments/get_shipment_deal_details/get_shipment_deal_details.dart';
import 'package:hatly/data/api/shipments/get_shipments_response/get_shipments_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_deals_response/my_shipment_deals_response.dart';
import 'package:hatly/data/api/shipments/my_shipment_response/my_shipment_response.dart';
import 'package:hatly/data/api/trip_deal/deals.dart' as TripDeal;
import 'package:hatly/data/api/shipment_deal/deals.dart' as ShipmentDeal;
import 'package:hatly/data/api/trip_deal/trip_deal_request.dart';
import 'package:hatly/data/api/trip_deal/trip_deal_response.dart';
import 'package:hatly/data/api/trips/create_trip_request/create_trip_request.dart';
import 'package:hatly/data/api/trips/create_trip_response/create_trip_response.dart';
import 'package:hatly/data/api/trips/get_all_trips_response/get_all_trips_response/get_all_trips_response.dart';
import 'package:hatly/data/api/trips/get_user_trip_response/get_user_trip_response.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'interceptor/LoggingInterceptor.dart';

class ApiManager {
  static const String baseUrl = 'hatlyapi.onrender.com';
  final AccessTokenProvider? accessTokenProvider;
  Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );

  ApiManager({this.accessTokenProvider});

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
      var url = Uri.https(baseUrl, 'auth/register');
      var requestBody = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: '+$phone',
        password: password,
        fcmToken: fcmToken,
        dob: '2000-02-02',
        address: 'London',
        city: 'London',
        country: 'GB',
        postalCode: 'SO15',
        ip: ip,
      );
      response = await client.post(url,
          body: requestBody.toJson(),
          headers: {'content-type': 'application/json'});
      var registerResponse = RegisterResponse.fromJson(response.body);

      if (registerResponse.status == false) {
        throw ServerErrorException(
            errorMessage: registerResponse.message!,
            statusCode: response.statusCode);
      }
      return registerResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<Countries> getCountriesFlags() async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'assets');
      response = await client.get(url);

      var countriesResponse = Countries.fromJson(response.body);
      return countriesResponse;
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
      var url = Uri.https(baseUrl, 'auth/login');
      var requestBody = LoginRequest(
        email: email,
        password: password,
      );
      List<String> splitted = [];
      response = await client.post(url,
          body: requestBody.toJson(),
          headers: {'content-type': 'application/json'});
      var responseHeaders = response.headers;
      var refreshTokenList = responseHeaders['set-cookie']?.split(';');

      var refreshToken = refreshTokenList![0].split('=');
      print('token ${refreshToken[1]}');
      await const FlutterSecureStorage()
          .write(key: 'refreshToken', value: refreshToken[1]);

      var loginResponse = LoginResponse.fromJson(response.body);

      if (loginResponse.status == false) {
        print('error ${loginResponse.message}');
        throw ServerErrorException(
            errorMessage: loginResponse.message!,
            statusCode: response.statusCode);
      }
      return loginResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<String> refreshAccessToken() async {
    String? refreshToken =
        await const FlutterSecureStorage().read(key: 'refreshToken');
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'auth/refresh-token');
      response = await client.post(url, headers: {
        'content-type': 'application/json',
        'cookie': 'refreshToken=$refreshToken',
      });
      var refreshResponse = RefreshAccessTokenResponse.fromJson(response.body);

      if (refreshResponse.status == false) {
        print('error ${response.statusCode}');
        throw ServerErrorException(
            errorMessage: refreshResponse.message!,
            statusCode: response.statusCode);
      }
      // await const FlutterSecureStorage()
      //     .write(key: 'accessToken', value: refreshResponse.accessToken);
      accessTokenProvider?.setAccessToken(refreshResponse.accessToken!);
      return refreshResponse.accessToken!;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<bool> chechAccessTokenExpired() async {
    String? accessToken =
        await const FlutterSecureStorage().read(key: 'accessToken');
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'auth/check');
      var requestBody = CheckAcessTokenRequest(token: accessToken);
      response = await client.post(url,
          headers: {
            'content-type': 'application/json',
          },
          body: requestBody.toJson());
      var checkResponse = CheckAccessTokenResponse.fromJson(response.body);

      return checkResponse.status!;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<GetShipmentsResponse> getAllShipmentsWithCheckAccessToken(
      {required String accessToken, int page = 1}) async {
    try {
      if (await chechAccessTokenExpired()) {
        return await getAllShipments(accessToken: accessToken, page: page);
      } else {
        var newAccessToken = await refreshAccessToken();
        return await getAllShipments(accessToken: newAccessToken, page: page);
      }
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: e.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<GetShipmentsResponse> getAllShipments(
      {required String accessToken, int page = 1}) async {
    late Response response;

    try {
      var url = Uri.https(baseUrl, 'shipments',
          {'page': page.toString(), 'take': 4.toString()});
      response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var getResponse = GetShipmentsResponse.fromJson(response.body);
      if (getResponse.status == false) {
        throw ServerErrorException(
            errorMessage: getResponse.message!,
            statusCode: response.statusCode);
      }
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

  Future<MyShipmentDealsResponse> getMyShipmentDeals(
      {required String accessToken, required int shipmentId}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'shipments/${shipmentId.toString()}/deals');
      response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var getResponse = MyShipmentDealsResponse.fromJson(response.body);
      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          getMyShipmentDeals(
              accessToken: newAccessToken, shipmentId: shipmentId);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<GetMyShipmentDealDetailsResponse> getMyShipmentDealDetails(
      {required String accessToken, required String dealId}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}');
      response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var getResponse =
          GetMyShipmentDealDetailsResponse.fromJson(response.body);
      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          getMyShipmentDealDetails(accessToken: newAccessToken, dealId: dealId);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<AcceptOrRejectShipmentDealResponse> acceptShipmentDeal(
      {required String accessToken,
      required String dealId,
      required String status}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deal/${dealId.toString()}/shipment', {
        'status': status,
      });
      response = await client.post(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var getResponse =
          AcceptOrRejectShipmentDealResponse.fromJson(response.body);
      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          acceptShipmentDeal(
              accessToken: newAccessToken, dealId: dealId, status: status);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<AcceptOrRejectShipmentDealResponse> rejectShipmentDeal(
      {required String accessToken,
      required String dealId,
      required String status}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deal/${dealId.toString()}/shipment', {
        'status': status,
      });
      response = await client.post(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var getResponse =
          AcceptOrRejectShipmentDealResponse.fromJson(response.body);
      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          rejectShipmentDeal(
              accessToken: newAccessToken, dealId: dealId, status: status);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<GetAllTripsResponse> getAllTripsWithCheckAccessToken(
      {required String accessToken, int page = 1}) async {
    try {
      if (await chechAccessTokenExpired()) {
        return await getAllTrips(accessToken: accessToken, page: page);
      } else {
        var newAccessToken = await refreshAccessToken();
        return await getAllTrips(accessToken: newAccessToken, page: page);
      }
    } on ServerErrorException catch (e) {
      throw ServerErrorException(errorMessage: e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<GetAllTripsResponse> getAllTrips(
      {required String accessToken, int page = 1}) async {
    late Response response;
    try {
      var url = Uri.https(
          baseUrl, 'trips', {'page': page.toString(), 'take': 4.toString()});
      response = await client
          .get(url, headers: {'authorization': 'Bearer $accessToken'});
      var getResponse = GetAllTripsResponse.fromJson(response.body);
      print('trip api');

      if (getResponse.status == false) {
        throw ServerErrorException(
            errorMessage: getResponse.message!,
            statusCode: response.statusCode);
      }
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
      var url = Uri.https(baseUrl, 'users/shipments');
      response = await client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
      );

      var getResponse = MyShipmentResponse.fromJson(response.body);
      print('apiii');

      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          getUserShipments(accessToken: newAccessToken);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<MyShipmentResponse> getMyShipmentsWithCheckAccessToken(
      {required String accessToken}) async {
    try {
      if (await chechAccessTokenExpired()) {
        return await getUserShipments(accessToken: accessToken);
      } else {
        var newAccessToken = await refreshAccessToken();
        return await getUserShipments(accessToken: newAccessToken);
      }
    } on ServerErrorException catch (e) {
      throw ServerErrorException(errorMessage: e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<GetUserTripResponse> getUserTrips(
      {required String accessToken}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'users/trips');
      response = await client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
      );

      var getResponse = GetUserTripResponse.fromJson(response.body);

      if (getResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          getUserTrips(accessToken: newAccessToken);
        } else {
          throw ServerErrorException(
              errorMessage: getResponse.message!,
              statusCode: response.statusCode);
        }
      }

      return getResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<TripDealResponse> sendTripDeal(
      {int? shipmentId,
      double? reward,
      required String accessToken,
      required int tripId}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deals/trip', {
        'tripId': tripId.toString(),
      });
      var requestBody = TripDealRequest(
          deals: TripDeal.Deals(shipmentId: shipmentId, reward: reward));
      print(url.toString());
      response = await client.post(url, body: requestBody.toJson(), headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var tripDealResponse = TripDealResponse.fromJson(response.body);
      if (tripDealResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          sendTripDeal(
              accessToken: newAccessToken,
              shipmentId: shipmentId,
              reward: reward,
              tripId: tripId);
        } else {
          throw ServerErrorException(
              errorMessage: tripDealResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return tripDealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<ShipmentDealResponse> sendShipmentDeal(
      {required int? shipmentId,
      required double? reward,
      required String accessToken,
      required int tripId}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deals/shipment', {
        'shipmentId': shipmentId.toString(),
      });
      var requestBody = ShipmentDealRequest(
          deals: ShipmentDeal.Deals(
              tripId: tripId,
              reward: reward,
              hatlyFees: 2.5,
              paymentFees: 2.3));
      print(url.toString());
      response = await client.post(url, body: requestBody.toJson(), headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var shipmentDealResponse = ShipmentDealResponse.fromJson(response.body);
      if (shipmentDealResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          sendShipmentDeal(
              accessToken: newAccessToken,
              tripId: tripId,
              shipmentId: shipmentId,
              reward: reward);
        } else {
          throw ServerErrorException(
              errorMessage: shipmentDealResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return shipmentDealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
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
      required String accessToken}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'trips');
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
      response = await client.post(url, body: requestBody.toJson(), headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });

      var tripResponse = CreateTripResponse.fromJson(response.body);
      if (tripResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          createTrip(
            accessToken: newAccessToken,
            itemsNotAllowed: itemsNotAllowed,
            notNeed: notNeed,
            bookInfo: bookInfo,
            departDate: departDate,
            addressMeeting: addressMeeting,
            note: note,
            available: available,
            destinationCity: destinationCity,
            destination: destination,
            origin: origin,
            originCity: originCity,
          );
        } else {
          throw ServerErrorException(
              errorMessage: tripResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return tripResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<RefreshTokenResponse> refreshFCMToken(
      {required String accessToken, required String fcmToken}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'users/refresh-fcm');
      var requestBody = RefreshTokenRequest(fcmToken: fcmToken);
      response = await client.patch(
        url,
        body: requestBody.toJson(),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
      );
      var refreshTokenResponse = RefreshTokenResponse.fromJson(response.body);
      if (refreshTokenResponse.status == false) {
        throw ServerErrorException(
            errorMessage: refreshTokenResponse.message!,
            statusCode: response.statusCode);
      }
      return refreshTokenResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<CounterOfferResponse> makeCounterOffer(
      {required int dealId,
      required double reward,
      required String accessToken}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/counter-offer', {
        'reward': reward,
      });
      response = await client.patch(url, headers: {
        'authorization': 'Bearer $accessToken',
      });
      var counterOfferResponse = CounterOfferResponse.fromJson(response.body);
      if (counterOfferResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          makeCounterOffer(
              accessToken: newAccessToken, reward: reward, dealId: dealId);
        } else {
          throw ServerErrorException(
              errorMessage: counterOfferResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return counterOfferResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
    }
  }

  Future<CancelDealResponse> cancelDeal(
      {required int dealId, required String accessToken}) async {
    late Response response;
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/cancel');
      response = await client.patch(url, headers: {
        'authorization': 'Bearer $accessToken',
      });
      var cancelDealResponse = CancelDealResponse.fromJson(response.body);
      if (cancelDealResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          cancelDeal(accessToken: newAccessToken, dealId: dealId);
        } else {
          throw ServerErrorException(
              errorMessage: cancelDealResponse.message!,
              statusCode: response.statusCode);
        }
      }
      return cancelDealResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(
          errorMessage: e.errorMessage, statusCode: response.statusCode);
    } on Exception catch (e) {
      throw ServerErrorException(
          errorMessage: e.toString(), statusCode: response.statusCode);
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
      required String accessToken}) async {
    late Response response;
    try {
      print('item api: $note');
      var url = Uri.https(baseUrl, 'shipments');
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

      response = await client.post(url, body: requestBody.toJson(), headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      });
      var shipmentResponse = CreateShipmentsResponse.fromJson(response.body);

      if (shipmentResponse.status == false) {
        if (response.statusCode == 401) {
          String newAccessToken = await refreshAccessToken();
          createShipment(
            accessToken: newAccessToken,
            items: items,
            reward: reward,
            date: date,
            to: to,
            toCity: toCity,
            fromCity: fromCity,
            from: from,
            note: note,
            title: title,
          );
        } else {
          throw ServerErrorException(
              errorMessage: shipmentResponse.message!,
              statusCode: response.statusCode);
        }
      }
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
