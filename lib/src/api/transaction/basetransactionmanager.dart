// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../flutterduplo.dart';
import '../../constant/encryptstring.dart';
import '../../models/bank.dart';
import '../../models/checkout_response.dart';
import '../../request/apis.dart';
import '../../request/env_variable.dart';
import '../../ui/pin_widget.dart';
import '../../ui/webview.dart';
import '../../wallet/otp_widget.dart';
import '../model/transaction_api_response.dart';

abstract class BaseTransactionManager {
  final Charge charge;
  final BuildContext context;
  final String publicKey, secretKey;

  BaseTransactionManager({
    required this.charge,
    required this.context,
    required this.publicKey,
    required this.secretKey,
  });

  Future<CheckoutResponse> initiate() async {
    String res;
    var iv = charge.reference!.substring(0, 16);
    var key = publicKey.substring(0, 32);
    String expiryMonth = charge.card!.expiryMonth.toString();

    var card = {
      "cvv": charge.card!.cvc,
      "expiryMonth": expiryMonth.length == 1 ? "0$expiryMonth" : expiryMonth,
      "expiryYear": charge.card!.expiryYear.toString(),
      "number": charge.card!.number
    };
    var jsonBody;
    if (charge.currency == "NGN") {
      jsonBody = {
        "amount": (charge.amount ~/ 100).toString(),
        "card": encrypt(jsonEncode(card), iv, key),
        "currency": charge.currency,
        "email": charge.email,
        "pin": charge.card!.pin,
        "reference":
            charge.reference //"refcard${DateTime.now().microsecondsSinceEpoch}"
      };
    } else {
      jsonBody = {
        "amount": (charge.amount ~/ 100).toString(),
        "card": encrypt(jsonEncode(card), iv, key),
        "currency": charge.currency,
        "email": charge.email,
        "reference":
            charge.reference //"refcard${DateTime.now().microsecondsSinceEpoch}"
      };
    }

    res = await depositcard(jsonBody, secretKey);
    var response;
    var cmddetails = jsonDecode(res);
    log(cmddetails.toString());
    if (cmddetails['status']) {
      try {
        if (charge.currency == "NGN") {
          if (cmddetails['data']['_links']['url'] != null) {
            return getOtpFrmUI(
                message: cmddetails['message'],
                links: cmddetails['data']['_links'],
                paymentid: cmddetails['data']['paymentid']);
          }
        } else {
          if (cmddetails['message'] == "Payment Successful") {
            return CheckoutResponse(
                message: cmddetails['message'],
                reference: charge.reference,
                status: true,
                card: charge.card?..nullifyNumber(),
                method: CheckoutMethod.card,
                verify: false);
          }

          if (cmddetails['alt'] != null) {
            getAuthFrmUI(cmddetails['alt']);
            return verifytransact();
          }
        }
      } catch (e) {
        response = CheckoutResponse(
            message: cmddetails['message'],
            reference: charge.reference,
            status: true,
            card: charge.card?..nullifyNumber(),
            method: CheckoutMethod.card,
            verify: false);
      }
    } else {
      if (cmddetails['message'] != "No internet connection") {
        response = CheckoutResponse(
            message: cmddetails['message'],
            reference: charge.reference,
            status: false,
            card: charge.card?..nullifyNumber(),
            method: CheckoutMethod.card,
            verify: false);
      }
    }
    return response;
  }

  Future<CheckoutResponse> otpinitiate(links, otp, paymentid) async {
    var jsonBody = {"otp": otp, "ref": charge.reference, "payid": paymentid};

    var respons;
    try {
      http.Response response;
      if (links["method"] == "POST") {
        response = await http.post(Uri.parse(links["url"]), body: jsonBody);
      } else {
        response = await http.get(Uri.parse(links["url"]));
      }
      respons = response.body;
      var cmddetails = jsonDecode(respons);
      if (debug) {
        if (kDebugMode) {
          print("method: $respons");
        }
      }

      if (cmddetails['status']) {
        // return getAuthFrmUI(cmddetails['data']['_links']['url']);
        respons = CheckoutResponse(
            message: cmddetails['message'],
            reference: charge.reference,
            status: true,
            card: charge.card?..nullifyNumber(),
            method: CheckoutMethod.card,
            verify: true);
        return respons;
      } else {
        if (cmddetails['message'] != "No internet connection") {
          respons = CheckoutResponse(
              message: cmddetails['message'],
              reference: charge.reference,
              status: false,
              card: charge.card?..nullifyNumber(),
              method: CheckoutMethod.card,
              verify: false);
        }
      }
    } on Exception {
      // nonetwork();

      if (debug) {
        if (kDebugMode) {
          print(Exception);
        }
      }
    }
    // setState(() {
    //   isLoading = false;
    // });

    return respons;
  }

  Future<CheckoutResponse> banktransaction() async {
    // List<int> expiryDate = CardUtils.getExpiryDate(expireController.text);
    //
    // String _expiryMonth = expiryDate[0].toString();
    // String _expiryYear = expiryDate[1].toString();
    String res;
    // setState(() {
    //   isLoading = true;
    // });
    var jsonBody = {
      "email": charge.email,
      "amount": (charge.amount ~/ 100).toString(),
      "currency": charge.currency,
      "reference": charge.reference
    };

    res = await deposittransfer(jsonBody, secretKey);
    var response;
    var cmddetails = jsonDecode(res);
    // setState(() {
    //   isLoading = false;
    // });

    if (cmddetails['status']) {
      response = CheckoutResponse(
          message: cmddetails['message'],
          reference: charge.reference,
          status: false,
          card: charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false);
      charge.account ??= BankAccount(
          Bank(cmddetails['data']['bank_name'], 1),
          cmddetails['data']['account_number'],
          cmddetails['data']['account_name']);
    } else {
      if (cmddetails['message'] != "No internet connection") {
        response = CheckoutResponse(
            message: cmddetails['message'],
            reference: charge.reference,
            status: false,
            card: charge.card?..nullifyNumber(),
            method: CheckoutMethod.card,
            verify: false);
      }
    }
    return response;
  }

  Future<CheckoutResponse> verifytransact() async {
    String res;
    res = await verifytransaction(charge.reference, secretKey);
    var cmddetails = jsonDecode(res);
    if (cmddetails['status']) {
      if (cmddetails['data']["status"] == "pending") {
        var result;
        Future.delayed(const Duration(milliseconds: 500), () {
          result = verifytransact();
        });
        return result;
      } else {
        Navigator.pop(context);
        if (cmddetails['data']["status"] == "success") {
          return CheckoutResponse(
              message: "Payment Success",
              reference: cmddetails['data']["reference"],
              status: true,
              card: charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false);
        } else {
          return CheckoutResponse(
              message: "Payment failed try with another card",
              reference: cmddetails['data']["reference"],
              status: false,
              card: charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false);
        }
      }
    } else {
      Navigator.pop(context);
      return CheckoutResponse(
          message: cmddetails['message'],
          reference: charge.reference,
          status: false,
          card: charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false);
    }
  }

  Future<CheckoutResponse> getOtpFrmUI(
      {String? message,
      TransactionApiResponse? response,
      var links,
      var paymentid}) async {
    assert(message != null || response != null);
    String? otp = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => OtpWidget(
            // ignore: unnecessary_null_comparison
            message: message! != null
                ? message
                : response!.displayText == null || response.displayText!.isEmpty
                    ? response.message
                    : response.displayText));

    if (otp != null && otp.isNotEmpty) {
      return otpinitiate(links, otp, paymentid);
      // return handleOtpInput(otp, response);
    } else {
      return notifyProcessingError(
          DuploException("You did not provide an OTP"));
    }
  }

  Future<CheckoutResponse> getPinFrmUI() async {
    String? pin = await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => PinWidget(onpress: (){},));

    if (pin != null && pin.length == 4) {
      charge.card!.pin = pin;
      return initiate();
      // return handlePinInput(pin);
    } else {
      return notifyProcessingError(
          DuploException("PIN must be exactly 4 digits"));
    }
  }

  Future<CheckoutResponse> handlePinInput(String pin) {
    throw UnsupportedError(
        "Pin Input not supported for ${CheckoutMethod.card}");
  }

  CheckoutResponse notifyProcessingError(Object e) {
    setProcessingOff();

    if (e is TimeoutException || e is SocketException) {
      e = 'Please check your internet connection or try again later';
    }
    return CheckoutResponse(
        message: e.toString(),
        reference: charge.reference,
        status: false,
        card: charge.card?..nullifyNumber(),
        account: charge.account,
        method: CheckoutMethod.card,
        verify: e is! DuploException);
  }

  bool processing = false;

  setProcessingOff() => processing = false;

  Future<CheckoutResponse> getAuthFrmUI(String? url) async {
    String? result = "";
    TransactionApiResponse apiResponse =
        TransactionApiResponse.unknownServerResponse();

    Future<void> doit({String? result}) async {
      try {
        log(json.decode(result!));

        Map<String, dynamic> responseMap = json.decode(json.decode(result));
        apiResponse = TransactionApiResponse.fromMap(responseMap);
      } catch (e) {
        log(e.toString());
      }
    }

//5368 9887 4790 4960
    //0525
    //584
    if (kDebugMode) {
      print(url!);
    }
    await showDialog(
        context: context,
        builder: (_) {
          // Future
          return Dialog(
            child: Builder(builder: (context) {
              return SizedBox(
                height: 300,
                child: WebView(
                  url: url!,
                ),
              );
            }),
          );
        }).then((values) async {
      result = await value();
      if (result != "") {
        await doit(result: result);
      }
    }).then((value) async {
      await doit(result: result);
    });

    return _initApiResponse(apiResponse);
  }

  Future<CheckoutResponse> handleApiResponse(
      TransactionApiResponse apiResponse);

  Future<CheckoutResponse> _initApiResponse(
      TransactionApiResponse? apiResponse) {
    apiResponse ??= TransactionApiResponse.unknownServerResponse();

    // transaction.loadFromResponse(apiResponse);

    return handleApiResponse(apiResponse);
  }

  Future<CheckoutResponse> handleServerResponse(
      Future<TransactionApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyProcessingError(e);
    }
  }
}
