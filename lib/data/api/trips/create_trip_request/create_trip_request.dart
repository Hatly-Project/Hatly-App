import 'dart:convert';

import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/items_not_allowed.dart';

class CreateTripRequest {
  String? origin, originCity;
  String? destination, destinationCity;
  int? available;
  String? note;
  String? addressMeeting;
  String? departDate;
  BookInfo? bookInfo;
  List<ItemsNotAllowed>? itemsNotAllowed;

  CreateTripRequest({
    this.origin,
    this.destination,
    this.available,
    this.note,
    this.originCity,
    this.destinationCity,
    this.addressMeeting,
    this.departDate,
    this.bookInfo,
    this.itemsNotAllowed,
  });

  factory CreateTripRequest.fromMap(Map<String, dynamic> data) {
    return CreateTripRequest(
      origin: data['origin'] as String?,
      destination: data['destination'] as String?,
      originCity: data['originCity'] as String?,
      destinationCity: data['destinationCity'] as String?,
      available: data['available'] as int?,
      note: data['note'] as String?,
      addressMeeting: data['addressMeeting'] as String?,
      departDate: data['departDate'] as String?,
      bookInfo: data['bookInfo'] == null
          ? null
          : BookInfo.fromMap(data['bookInfo'] as Map<String, dynamic>),
      itemsNotAllowed: (data['itemsNotAllowed'] as List<dynamic>?)
          ?.map((e) => ItemsNotAllowed.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'origin': origin,
        'destination': destination,
        'originCity': originCity,
        'destinationCity': destinationCity,
        'available': available,
        'note': note,
        'addressMeeting': addressMeeting,
        'departDate': departDate,
        'bookInfo': bookInfo?.toMap(),
        'itemsNotAllowed': itemsNotAllowed?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CreateTripRequest].
  factory CreateTripRequest.fromJson(String data) {
    return CreateTripRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CreateTripRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
