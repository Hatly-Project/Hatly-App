import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/cancel_deal_response.dart';
import 'package:hatly/data/api/counter_offer.dart';
import 'package:hatly/data/api/countries_states/countries.dart';
import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/api/login/login_request.dart';
import 'package:hatly/data/api/login/login_response/login_response.dart';
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
import 'package:http_interceptor/http/intercepted_client.dart';
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
      var url = Uri.https(baseUrl, 'auth/login');
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

  Future<GetShipmentsResponse> getAllShipments(
      {required String token, int page = 1}) async {
    try {
      var url = Uri.https(baseUrl, 'shipments',
          {'page': page.toString(), 'take': 4.toString()});
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
      var url = Uri.https(baseUrl, 'shipments/${shipmentId.toString()}/deals');
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

  Future<GetMyShipmentDealDetailsResponse> getMyShipmentDealDetails(
      {required String token, required String dealId}) async {
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}');
      var response = await client.get(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      });

      var getResponse =
          GetMyShipmentDealDetailsResponse.fromJson(response.body);
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

  Future<AcceptOrRejectShipmentDealResponse> acceptShipmentDeal(
      {required String token,
      required String dealId,
      required String status}) async {
    try {
      var url = Uri.https(baseUrl, 'deal/${dealId.toString()}/shipment', {
        'status': status,
      });
      var response = await client.post(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      });

      var getResponse =
          AcceptOrRejectShipmentDealResponse.fromJson(response.body);
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

  Future<AcceptOrRejectShipmentDealResponse> rejectShipmentDeal(
      {required String token,
      required String dealId,
      required String status}) async {
    try {
      var url = Uri.https(baseUrl, 'deal/${dealId.toString()}/shipment', {
        'status': status,
      });
      var response = await client.post(url, headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      });

      var getResponse =
          AcceptOrRejectShipmentDealResponse.fromJson(response.body);
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

  Future<GetAllTripsResponse> getAllTrips(
      {required String token, int page = 1}) async {
    try {
      var url = Uri.https(
          baseUrl, 'trips', {'page': page.toString(), 'take': 4.toString()});
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
      var url = Uri.https(baseUrl, 'users/shipments');
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
      var url = Uri.https(baseUrl, 'users/trips');
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
      var url = Uri.https(baseUrl, 'deals/trip', {
        'tripId': tripId.toString(),
      });
      var requestBody = TripDealRequest(
          deals: TripDeal.Deals(shipmentId: shipmentId, reward: reward));
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

  Future<ShipmentDealResponse> sendShipmentDeal(
      {required int? shipmentId,
      required double? reward,
      required String token,
      required int tripId}) async {
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
      var response = await client.post(url,
          body: requestBody.toJson(),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          });

      var shipmentDealResponse = ShipmentDealResponse.fromJson(response.body);
      if (shipmentDealResponse.status == false) {
        throw ServerErrorException(shipmentDealResponse.message!);
      }
      return shipmentDealResponse;
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

  Future<RefreshTokenResponse> refreshFCMToken(
      {required String token, required String fcmToken}) async {
    try {
      var url = Uri.https(baseUrl, 'users/refresh-fcm');
      var requestBody = RefreshTokenRequest(fcmToken: fcmToken);
      var response = await client.patch(
        url,
        body: requestBody.toJson(),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      var refreshTokenResponse = RefreshTokenResponse.fromJson(response.body);
      if (refreshTokenResponse.status == false) {
        throw ServerErrorException(refreshTokenResponse.message!);
      }
      return refreshTokenResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<CounterOfferResponse> makeCounterOffer(
      {required int dealId,
      required double reward,
      required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/counter-offer', {
        'reward': reward,
      });
      var response = await client.patch(url, headers: {
        'authorization': 'Bearer $token',
      });
      var counterOfferResponse = CounterOfferResponse.fromJson(response.body);
      if (counterOfferResponse.status == false) {
        throw ServerErrorException(counterOfferResponse.message!);
      }
      return counterOfferResponse;
    } on ServerErrorException catch (e) {
      throw ServerErrorException(e.errorMessage);
    } on Exception catch (e) {
      throw ServerErrorException(e.toString());
    }
  }

  Future<CancelDealResponse> cancelDeal(
      {required int dealId, required String token}) async {
    try {
      var url = Uri.https(baseUrl, 'deals/${dealId.toString()}/cancel');
      var response = await client.patch(url, headers: {
        'authorization': 'Bearer $token',
      });
      var cancelDealResponse = CancelDealResponse.fromJson(response.body);
      if (cancelDealResponse.status == false) {
        throw ServerErrorException(cancelDealResponse.message!);
      }
      return cancelDealResponse;
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
