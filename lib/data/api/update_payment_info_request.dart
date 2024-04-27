import 'dart:convert';

import 'package:hatly/data/api/update_payment_info_response.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

class UpdatePaymentInfoRequest {
  String? accountNumber;
  String? routingNumber;
  String? accountName;
  String? accountCurrency;
  String? accountCountry;

  UpdatePaymentInfoRequest({
    this.accountNumber,
    this.routingNumber,
    this.accountName,
    this.accountCurrency,
    this.accountCountry,
  });

  factory UpdatePaymentInfoRequest.fromMap(Map<String, dynamic> data) {
    return UpdatePaymentInfoRequest(
      accountNumber: data['accountNumber'] as String?,
      routingNumber: data['routingNumber'] as String?,
      accountName: data['accountName'] as String?,
      accountCurrency: data['accountCurrency'] as String?,
      accountCountry: data['accountCountry'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'accountNumber': accountNumber,
        'routingNumber': routingNumber,
        'accountName': accountName,
        'accountCurrency': accountCurrency,
        'accountCountry': accountCountry,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UpdatePaymentInfoRequest].
  factory UpdatePaymentInfoRequest.fromJson(String data) {
    return UpdatePaymentInfoRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UpdatePaymentInfoRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
