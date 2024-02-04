import 'dart:convert';

import 'package:hatly/data/api/book_info.dart';

class BookInfoDto {
  int? id;

  String? firstName;
  String? lastName;
  String? bookingReference;
  String? airline;

  BookInfoDto({
    this.id,
    this.firstName,
    this.lastName,
    this.bookingReference,
    this.airline,
  });

  factory BookInfoDto.fromMap(Map<String, dynamic> data) => BookInfoDto(
        id: data['id'] as int?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        bookingReference: data['bookingReference'] as String?,
        airline: data['airline'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'bookingReference': bookingReference,
        'airline': airline,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BookInfo].
  factory BookInfoDto.fromJson(String data) {
    return BookInfoDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BookInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  BookInfo toBookInfo() {
    return BookInfo(
      airline: airline,
      firstName: firstName,
      lastName: lastName,
      bookingReference: bookingReference,
      id: id,
    );
  }
}
