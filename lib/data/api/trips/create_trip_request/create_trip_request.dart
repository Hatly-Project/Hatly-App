import 'dart:convert';

class CreateTripRequest {
  String? origin;
  String? destination;
  int? available;
  String? note;
  String? addressMeeting;
  String? departData;
  String? notNeed;

  CreateTripRequest({
    this.origin,
    this.destination,
    this.available,
    this.note,
    this.addressMeeting,
    this.departData,
    this.notNeed,
  });

  factory CreateTripRequest.fromMap(Map<String, dynamic> data) {
    return CreateTripRequest(
      origin: data['origin'] as String?,
      destination: data['destination'] as String?,
      available: data['available'] as int?,
      note: data['note'] as String?,
      addressMeeting: data['addressMeeting'] as String?,
      departData: data['DepartData'] as String?,
      notNeed: data['notNeed'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'origin': origin,
        'destination': destination,
        'available': available,
        'note': note,
        'addressMeeting': addressMeeting,
        'DepartData': departData,
        'notNeed': notNeed,
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
