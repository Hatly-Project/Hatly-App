import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';

import '../models/create_shipment_response_dto.dart';
import '../models/item_dto.dart';

abstract class ShipmentRepository {
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
      required String token});

  Future<GetAllShipmentResponseDto> getAllShipments(String token);
  Future<GetUserShipmentsDto> getUserShipments({required String token});

  Future<MyShipmentDealsResponseDto> getMyShipmentDeals(
      {required String token, required int shipmentId});

  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId});

  Future<ShipmentDealResponseDto> sendDeal(
      {required String token,
      required int? shipmentId,
      required double? reward,
      required int tripId});
}
