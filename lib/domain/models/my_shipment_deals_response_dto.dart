import 'dart:convert';

import 'package:hatly/data/api/shipmentDeal.dart';
import 'package:hatly/domain/models/deal_dto.dart';

class MyShipmentDealsResponseDto {
  bool? status;
  String? message;
  List<DealDto>? deals;

  MyShipmentDealsResponseDto({this.status, this.deals, this.message});
}
