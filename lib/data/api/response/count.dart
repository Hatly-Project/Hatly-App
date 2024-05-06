import 'dart:convert';

class Count {
  int? deals;

  Count({this.deals});

  factory Count.fromMap(Map<String, dynamic> data) => Count(
        deals: data['deals'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'deals': deals,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Count].
  factory Count.fromJson(String data) {
    return Count.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Count] to a JSON string.
  String toJson() => json.encode(toMap());
}
