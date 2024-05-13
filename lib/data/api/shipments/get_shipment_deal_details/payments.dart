import 'dart:convert';

import 'package:hatly/domain/models/deal_payment_dto.dart';

class Payments {
  String? id;
  int? dealId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? currency;
  String? paymentIntentId;
  String? clientSecret;
  bool? isPaid;

  Payments({
    this.id,
    this.dealId,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.paymentIntentId,
    this.clientSecret,
    this.isPaid,
  });

  factory Payments.fromMap(Map<String, dynamic> data) => Payments(
        id: data['id'] as String?,
        dealId: data['dealId'] as int?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        currency: data['currency'] as String?,
        paymentIntentId: data['paymentIntentId'] as String?,
        clientSecret: data['clientSecret'] as String?,
        isPaid: data['isPaid'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'dealId': dealId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'currency': currency,
        'paymentIntentId': paymentIntentId,
        'clientSecret': clientSecret,
        'isPaid': isPaid,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Payments].
  factory Payments.fromJson(String data) {
    return Payments.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Payments] to a JSON string.
  String toJson() => json.encode(toMap());

  PaymentsDto toDto() {
    return PaymentsDto(
        id: id,
        dealId: dealId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        currency: currency,
        paymentIntentId: paymentIntentId,
        clientSecret: clientSecret,
        isPaid: isPaid);
  }
}
