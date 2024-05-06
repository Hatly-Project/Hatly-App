import 'dart:convert';

import 'book_info.dart';
import 'count.dart';
import 'items_not_allowed.dart';
import 'user.dart';

class Trip {
  int? id;
  String? origin;
  String? destination;
  String? originCity;
  String? destinationCity;
  int? available;
  int? consumed;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic note;
  String? addressMeeting;
  int? bookInfoId;
  DateTime? departDate;
  int? userId;
  BookInfo? bookInfo;
  List<ItemsNotAllowed>? itemsNotAllowed;
  User? user;
  Count? count;

  Trip({
    this.id,
    this.origin,
    this.destination,
    this.originCity,
    this.destinationCity,
    this.available,
    this.consumed,
    this.createdAt,
    this.updatedAt,
    this.note,
    this.addressMeeting,
    this.bookInfoId,
    this.departDate,
    this.userId,
    this.bookInfo,
    this.itemsNotAllowed,
    this.user,
    this.count,
  });

  factory Trip.fromMap(Map<String, dynamic> data) => Trip(
        id: data['id'] as int?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        originCity: data['originCity'] as String?,
        destinationCity: data['destinationCity'] as String?,
        available: data['available'] as int?,
        consumed: data['consumed'] as int?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        note: data['note'] as dynamic,
        addressMeeting: data['addressMeeting'] as String?,
        bookInfoId: data['bookInfoId'] as int?,
        departDate: data['departDate'] == null
            ? null
            : DateTime.parse(data['departDate'] as String),
        userId: data['userId'] as int?,
        bookInfo: data['bookInfo'] == null
            ? null
            : BookInfo.fromMap(data['bookInfo'] as Map<String, dynamic>),
        itemsNotAllowed: (data['itemsNotAllowed'] as List<dynamic>?)
            ?.map((e) => ItemsNotAllowed.fromMap(e as Map<String, dynamic>))
            .toList(),
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        count: data['_count'] == null
            ? null
            : Count.fromMap(data['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'originCity': originCity,
        'destinationCity': destinationCity,
        'available': available,
        'consumed': consumed,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'note': note,
        'addressMeeting': addressMeeting,
        'bookInfoId': bookInfoId,
        'departDate': departDate?.toIso8601String(),
        'userId': userId,
        'bookInfo': bookInfo?.toMap(),
        'itemsNotAllowed': itemsNotAllowed?.map((e) => e.toMap()).toList(),
        'user': user?.toMap(),
        '_count': count?.toMap(),
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
}
