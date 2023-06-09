import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/transaction/cardtransactionmanager.dart';
import '../models/charge.dart';
import '../models/checkout_response.dart';
import '../ui/checkout/checkout_widget.dart';
import 'exceptions.dart';
import 'platform_info.dart';
import 'string_utils.dart';
import 'utils.dart';

class Duplo {
  bool _sdkInitialized = false;
  String _publicKey = "";
  String _secretKey = "";
  static late PlatformInfo platformInfo;

  /// Initialize the Duplo object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your Duplo public key. This is mandatory
  ///
  /// use [checkout] and you want this plugin to initialize the transaction for you.
  /// Please check [checkout] for more information
  ///
  initialize({required String publicKey, required String secretKey}) async {
    assert(() {
      if (publicKey.isEmpty) {
        throw DuploException('publicKey cannot be null or empty');
      } else if (!publicKey.startsWith("pk_")) {
        throw DuploException(Utils.getKeyErrorMsg('public'));
      } else if (secretKey.isEmpty) {
        throw DuploException('secretKey cannot be null or empty');
      } else if (!secretKey.startsWith("sk_")) {
        throw DuploException(Utils.getKeyErrorMsg('secret'));
      } else {
        return true;
      }
    }());

    if (sdkInitialized) return;

    publicKey = publicKey;

    // Using cascade notation to build the platform specific info
    try {
      platformInfo = (await PlatformInfo.getinfo())!;
      _publicKey = publicKey;
      _secretKey = secretKey;
      _sdkInitialized = true;
    } on PlatformException {
      rethrow;
    }
  }

  dispose() {
    _publicKey = "";
    _secretKey = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  String get secretKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _secretKey;
  }

  void _performChecks() {
    //validate that sdk has been initialized
    _validateSdkInitialized();
    //check for null value, and length and starts with pk_
    if (_publicKey.isEmpty || !_publicKey.startsWith("pk_")) {
      throw AuthenticationException(Utils.getKeyErrorMsg('public'));
    } else if (_secretKey.isEmpty || !_secretKey.startsWith("sk_")) {
      throw AuthenticationException(Utils.getKeyErrorMsg('secret'));
    }
  }

  /// Make payment by charging the user's card
  ///
  /// [context] - the ui BuildContext
  ///
  /// [charge] - the charge object.

  Future<CheckoutResponse> chargeCard(BuildContext context,
      {required Charge charge}) {
    _performChecks();

    return _Duplo(publicKey, secretKey)
        .chargeCard(context: context, charge: charge);
  }

  /// Make payment using Duplo's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  ///
  /// [charge] - the charge object.
  ///
  /// Notes:
  ///
  /// * You can also pass the [PaymentCard] object and we'll use it to prepopulate the
  /// card  fields if card payment is being used
  ///
  /// [fullscreen] - Whether to display the payment in a full screen dialog or not
  ///
  /// [logo] - The widget to display at the top left of the payment prompt.
  /// Defaults to an Image widget with Duplo's logo.
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    CheckoutMethod method = CheckoutMethod.selectable,
    bool fullscreen = false,
    Widget? logo,
    bool hideEmail = false,
    bool hideAmount = false,
  }) async {
    return _Duplo(publicKey, secretKey).checkout(
      context,
      charge: charge,
      method: method,
      logo: logo,
      hideAmount: hideAmount,
      hideEmail: hideEmail,
    );
  }

  // Future checkout(BuildContext context, {required Charge charge}) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return Fundwallet(
  //           amount: charge.amount.toString(),
  //         );
  //       },
  //     ),
  //   );
  //   // Get.to(() => Fundwallet(
  //   //       amount: charge.amount.toString(),
  //   //     ));
  //   return null;
  // }

  // Future cardcheckout(BuildContext context, {required Charge charge}) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return Debitcard(
  //           amount: charge.amount.toString(),
  //         );
  //       },
  //     ),
  //   );
  //   return null;
  // }

  // Future chargeCard(BuildContext context, {required Charge charge}) {
  //   _performChecks();
  //
  //   return initiate(context, charge: charge);
  // }

  _validateSdkInitialized() {
    if (!sdkInitialized) {
      throw DuploSdkNotInitializedException(
          'Duplo SDK has not been initialized. The SDK has'
          ' to be initialized before use');
    }
  }
}

class _Duplo {
  final String publicKey;
  final String secretKey;
  _Duplo(this.publicKey, this.secretKey);

  Future<CheckoutResponse> chargeCard(
      {required BuildContext context, required Charge charge}) {
    return CardTransactionManager(
      context: context,
      charge: charge,
      publicKey: publicKey,
      secretKey: secretKey,
    ).cardservice();
  }

  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    required CheckoutMethod method,
    bool hideEmail = false,
    bool hideAmount = false,
    Widget? logo,
  }) async {
    assert(() {
      _validateChargeAndKey(charge);
      return true;
    }());
    CheckoutResponse? response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CheckoutWidget(
        publicKey: publicKey,
        secretKey: secretKey,
        // bankService: BankService(),
        // cardsService: CardService(),
        charge: charge,
        logo: logo,
        hideAmount: hideAmount,
        hideEmail: hideEmail,
      ),
    );
    return response!;
  }

  _validateChargeAndKey(Charge charge) {
    if (charge.amount.isNegative) {
      throw InvalidAmountException(charge.amount);
    }
    if (!StringUtils.isValidEmail(charge.email)) {
      throw InvalidEmailException(charge.email);
    }
  }
}

enum CheckoutMethod { card, bank, ussd, selectable }
