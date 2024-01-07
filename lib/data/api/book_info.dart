import 'dart:convert';

import 'package:hatly/domain/models/book_info_dto.dart';

class BookInfo {
  String? airline;
  String? bookingReference;
  String? firstName;
  String? lastName;

  BookInfo({
    this.airline,
    this.bookingReference,
    this.firstName,
    this.lastName,
  });

  factory BookInfo.fromMap(Map<String, dynamic> data) => BookInfo(
        airline: data['airline'] as String?,
        bookingReference: data['bookingReference'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'airline': airline,
        'bookingReference': bookingReference,
        'firstName': firstName,
        'lastName': lastName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BookInfo].
  factory BookInfo.fromJson(String data) {
    return BookInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BookInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  BookInfoDto toBookInfoDto() {
    return BookInfoDto(
        firstName: firstName,
        lastName: lastName,
        bookingReference: bookingReference,
        airline: airline);
  }
}
