import 'dart:convert';

import '../../flutterduplo.dart';
import '../common/my_strings.dart';
import 'bank.dart';

class Charge {
  PaymentCard? card;
  CheckoutMethod? method;

  /// The email of the customer
  String? email;
  BankAccount? _account;

  /// Amount to pay in base currency. Must be a valid positive number
  int _amount = 0;
  Map<String, dynamic>? _metadata;
  List<Map<String, dynamic>>? _customFields;
  bool _hasMeta = false;
  Map<String, String?>? _additionalParameters;

  /// The locale used for formatting amount in the UI prompt. Defaults to [Strings.nigerianLocale]
  String? locale;
  String? accessCode;
  String? plan;
  String? reference;

  /// ISO 4217 payment currency code (e.g USD). Defaults to [Strings.ngn].
  ///
  /// If you're setting this value, also set [locale] for better formatting.
  String? currency;
  int? transactionCharge;

  /// Who bears Duplo charges? [Bearer.account] or [Bearer.subAccount]
  Bearer? bearer;

  String? subAccount;

  Charge() {
    _metadata = {};
    amount = -1;
    _additionalParameters = {};
    _customFields = [];
    _metadata!['custom_fields'] = _customFields;
    locale = Strings.nigerianLocale;
    currency = Strings.ngn;
    method = CheckoutMethod.bank;
  }

  addParameter(String key, String value) {
    _additionalParameters![key] = value;
  }

  Map<String, String?>? get additionalParameters => _additionalParameters;

  BankAccount? get account => _account;

  set account(BankAccount? value) {
    if (value == null) {
      // Precaution to avoid setting of this field outside the library
      throw DuploException('account cannot be null');
    }
    _account = value;
  }

  putMetaData(String name, dynamic value) {
    _metadata![name] = value;
    _hasMeta = true;
  }

  putCustomField(String displayName, String value) {
    var customMap = {
      'value': value,
      'display_name': displayName,
      'variable_name':
          displayName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), "_")
    };
    _customFields!.add(customMap);
    _hasMeta = true;
  }

  String? get metadata {
    if (!_hasMeta) {
      return null;
    }

    return jsonEncode(_metadata);
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = multiplyBy100(value);
  }

  int multiplyBy100(int amount) {
    return amount * 100;
  }
}

enum Bearer {
  account,
  subAccount,
}
