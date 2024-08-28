import 'dart:convert';
import 'package:hatly/data/api/book_info.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/data/api/user.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class Trip {
  String? id;
  String? origin, originCity;
  String? destination, destinationCity;
  int? available;
  int? consumed;
  String? note;
  String? addressMeeting;
  DateTime? departDate;
  DateTime? createdAt;
  BookInfo? bookInfo;
  User? user;
  List<Shipment>? shipments;
  List<ItemsNotAllowed>? itemsNotAllowed;

  Trip({
    this.id,
    this.origin,
    this.destination,
    this.available,
    this.originCity,
    this.destinationCity,
    this.consumed,
    this.note,
    this.addressMeeting,
    this.departDate,
    this.createdAt,
    this.user,
    this.shipments,
    this.bookInfo,
    this.itemsNotAllowed,
  });

  factory Trip.fromMap(Map<String, dynamic> data) => Trip(
        id: data['id'] as String?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        originCity: data['originCity'] as String?,
        destinationCity: data['destinationCity'] as String?,
        available: data['available'] as int?,
        consumed: data['consumed'] as int?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        note: data['note'] as String?,
        addressMeeting: data['addressMeeting'] as String?,
        departDate: data['departDate'] == null
            ? null
            : DateTime.parse(data['departDate'] as String),
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        bookInfo: data['bookInfo'] == null
            ? null
            : BookInfo.fromMap(data['bookInfo'] as Map<String, dynamic>),
        itemsNotAllowed: (data['itemsNotAllowed'] as List<dynamic>?)
            ?.map((e) => ItemsNotAllowed.fromMap(e as Map<String, dynamic>))
            .toList(),
        shipments: (data['shipments'] as List<dynamic>?)
            ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'originCity': originCity,
        'destinationCity': destinationCity,
        'available': available,
        'note': note,
        'user': user?.toMap(),
        'shipments': shipments?.map((e) => e.toMap()).toList(),
        'addressMeeting': addressMeeting,
        'departDate': departDate?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'bookInfo': bookInfo?.toMap(),
        'itemsNotAllowed': itemsNotAllowed?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Trip].
  factory Trip.fromJson(String data) {
    return Trip.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Trip] to a JSON string.
  String toJson() => json.encode(toMap());

  TripsDto toTripsDto() {
    return TripsDto(
        id: id,
        origin: origin,
        destination: destination,
        originCity: originCity,
        destinationCity: destinationCity,
        available: available,
        consumed: consumed,
        note: note,
        addressMeeting: addressMeeting,
        departDate: departDate,
        createdAt: createdAt,
        bookInfo: bookInfo?.toBookInfoDto(),
        user: user?.toUserDto(),
        shipmentDto:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        itemsNotAllowed: itemsNotAllowed
            ?.map((item) => item.toItemsNotAllowedDto())
            .toList());
  }
}
