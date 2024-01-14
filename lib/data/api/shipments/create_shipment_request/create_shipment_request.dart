import 'dart:convert';

import 'package:hatly/data/api/item.dart';

class CreateShipmentRequest {
  String? title;
  String? from;
  String? to;
  String? note;
  String? expectedDate;
  double? reward;
  List<Item>? items;

  CreateShipmentRequest({
    this.title,
    this.from,
    this.to,
    this.expectedDate,
    this.reward,
    this.note,
    this.items,
  });

  factory CreateShipmentRequest.fromMap(Map<String, dynamic> data) {
    return CreateShipmentRequest(
      title: data['title'] as String?,
      from: data['from'] as String?,
      note: data['note'] as String?,
      to: data['to'] as String?,
      expectedDate: data['expectedDate'] as String?,
      reward: (data['reward'] as num?)?.toDouble(),
      items: (data['items'] as List<dynamic>?)
          ?.map((e) => Item.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'from': from,
        'to': to,
        'note': note,
        'expectedDate': expectedDate,
        'reward': reward,
        'items': items?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CreateShipmentRequest].
  factory CreateShipmentRequest.fromJson(String data) {
    return CreateShipmentRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CreateShipmentRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
