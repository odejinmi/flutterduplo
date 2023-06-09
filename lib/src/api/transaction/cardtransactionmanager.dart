import 'dart:async';

import '../../models/checkout_response.dart';
import '../model/transaction_api_response.dart';
import 'basetransactionmanager.dart';

class CardTransactionManager extends BaseTransactionManager {
  CardTransactionManager(
      {required charge,
      required context,
      required publicKey,
      required secretKey})
      : super(
            charge: charge,
            context: context,
            publicKey: publicKey,
            secretKey: secretKey);

  Future<CheckoutResponse> cardservice() async {
    // if (charge.currency == "NGN") {
    //   return getPinFrmUI();
    // } else {
      return initiate();
    // }
  }

  Future<CheckoutResponse> cardverify() async {
    return verifytransact();
  }

  Future<CheckoutResponse> bankservice() async {
    return banktransaction();
  }

  @override
  Future<CheckoutResponse> handleApiResponse(
      TransactionApiResponse apiResponse) {

    throw UnimplementedError();
  }
}
