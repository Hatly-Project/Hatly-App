import 'dart:convert';

class BookInfo {
  int? id;
  String? airline;
  String? bookingReference;
  String? firstName;
  String? lastName;

  BookInfo({
    this.id,
    this.airline,
    this.bookingReference,
    this.firstName,
    this.lastName,
  });

  factory BookInfo.fromMap(Map<String, dynamic> data) => BookInfo(
        id: data['id'] as int?,
        airline: data['airline'] as String?,
        bookingReference: data['bookingReference'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
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
}
