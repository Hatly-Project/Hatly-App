import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/models/deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  ShipmentDataSource shipmentDataSource;

  ShipmentRepositoryImpl(this.shipmentDataSource);
  @override
  Future<CreateShipmentsResponseDto> createShipment(
      {String? title,
      String? note,
      String? from,
      String? fromCity,
      String? toCity,
      String? to,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token}) {
    print('note repo $note');
    return shipmentDataSource.createShipment(
        token: token,
        title: title,
        note: note,
        from: from,
        fromCity: fromCity,
        toCity: toCity,
        to: to,
        date: date,
        reward: reward,
        items: items);
  }

  @override
  Future<GetAllShipmentResponseDto> getAllShipments({
    required String token,
    int page = 1,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) {
    return shipmentDataSource.getAllShipments(
      token: token,
      page: page,
      beforeExpectedDate: beforeExpectedDate,
      afterExpectedDate: afterExpectedDate,
      from: from,
      fromCity: fromCity,
      to: to,
      toCity: toCity,
      latest: latest,
    );
  }

  @override
  Future<GetUserShipmentsDto> getUserShipments({required String token}) {
    return shipmentDataSource.getUserShipments(token: token);
  }

  @override
  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId}) {
    return shipmentDataSource.getMyShipmentDeals(
        token: token, shipmentId: shipmentId);
  }

  // @override
  // Future<ShipmentMatchingTripsResponseDto> getShipmentMatchingTrips(
  //     {required String token,  int? shipmentId}) {
  //   return shipmentDataSource.getShipmentMatchingTrips(
  //       token: token, shipmentId: shipmentId);
  // }
}
