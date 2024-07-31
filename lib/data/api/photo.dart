import 'dart:convert';

import 'package:hatly/domain/models/photo_dto.dart';

class Photo {
  String? photo;

  Photo({this.photo});

  factory Photo.fromMap(Map<String, dynamic> data) => Photo(
        photo: data['url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'url': photo,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Photo].
  factory Photo.fromJson(String data) {
    return Photo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Photo] to a JSON string.
  String toJson() => json.encode(toMap());

  PhotoDto tophotoDto() {
    return PhotoDto(photo: photo);
  }
}
