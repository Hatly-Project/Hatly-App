import 'dart:convert';

import 'package:hatly/data/api/photo.dart';

class PhotoDto {
  String? photo;

  PhotoDto({this.photo});

  factory PhotoDto.fromMap(Map<String, dynamic> data) => PhotoDto(
        photo: data['photo'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'photo': photo,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PhotoDto].
  factory PhotoDto.fromJson(String data) {
    return PhotoDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PhotoDto] to a JSON string.
  String toJson() => json.encode(toMap());

  Photo toPhoto() {
    return Photo(photo: photo);
  }
}
