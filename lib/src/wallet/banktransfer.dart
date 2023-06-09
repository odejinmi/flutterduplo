// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutterduplo.dart';
import '../common/utils.dart';
import '../constant/constant.dart';
import '../constant/submitbutton.dart';
import '../models/checkout_response.dart';
import '../request/apis.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';
import '../ui/error_widget.dart';
import '../ui/sucessful_widget.dart';
import '../ui/topback.dart';
import 'copy.dart';
import 'transactionstatus.dart';

class Banktransfer extends StatefulWidget {
  final Charge charge;
  final String secretkey, publickey;
  final OnResponse<CheckoutResponse> onResponse;
  const Banktransfer(
      {Key? key,
      required this.secretkey,
      required this.publickey,
      required this.charge,
      required this.onResponse})
      : super(key: key);

  @override
  _BanktransferState createState() => _BanktransferState(charge, onResponse);
}

class _BanktransferState extends BaseCheckoutMethodState<Banktransfer> {
  final Charge _charge;
  _BanktransferState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.bank);

  String? _paymentError;
  bool _paymentSuccessful = false;

  CheckoutResponse? _response;
  void _onProcessingChange(bool processing) {
    setState(() {
      processing = processing;
    });
  }
  bool ischange = false;
  var isloading = false;

  void _onPaymentResponse(CheckoutResponse response) {
    if (kDebugMode) {
      print(response);
    }
    _response = response;
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
    if (response.status == true) {
      _onPaymentSuccess();
    } else {
      _onPaymentError(response.message);
    }
  }

  void _onPaymentSuccess() {
    setState(() {
      _paymentSuccessful = true;
      _paymentError = null;
      _onProcessingChange(false);
    });
  }

  void _onPaymentError(String? value) {
    setState(() {
      _paymentError = value;
      _paymentSuccessful = false;
      _onProcessingChange(false);
    });
  }

  void startloading() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        ischange = !ischange;
        startloading();
      });
    });
  }

  @override
  Widget buildAnimatedChild() {
    return _showProcessingError()
            ? _buildErrorWidget()
            : _paymentSuccessful
                ? _buildSuccessfulWidget()
                : Material(
                    color: Colors.white,
                    // elevation: 5.0,
                    // borderRadius: BorderRadius.circular(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: onCancelPress,
                              child: const Text("Cancel",
                                style: TextStyle(
                                    fontSize: 16.36,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff40B198)
                                ),),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Material(
                          color: Colors.white,
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Topback(charge: _charge, onResponse: onResponse),
                                  const SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      Utils.formatAmount(_charge.amount),
                                      style: GoogleFonts.dmSans(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Pay with Bank",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 22.14, fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "To complete the bank transfer, Kindly proceed  \n to your bank's mobile application ",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 11.07, fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Regenerate",
                                      style: GoogleFonts.dmSans(
                                        color: Color(0xff40B198),
                                          fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF7F9FD),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Amount",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w300),
                                            ),
                                            const Spacer(),
                                            Copy(
                                              quote: _charge.amount.toString(),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              Utils.formatAmount(_charge.amount),
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Bank Name",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w300),
                                            ),
                                            const Spacer(),
                                            Text(
                                              _charge.account!.bank!.name!,
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Account Number",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w300),
                                            ),
                                            const Spacer(),
                                            Copy(
                                              quote: _charge.account!.number!,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              _charge.account!.number!,
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Account Name",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w300),
                                            ),
                                            const Spacer(),
                                            Text(
                                              _charge.account!.name!,
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 12.56, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  !isloading ?
                                  Container(
                                    child: Column(
                                      children: [
                                        Text("Use this account for this transaction only. Account expires in 29 minutes",
                                          style: GoogleFonts.dmSans(
                                              fontSize: 11.25, fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        // const Spacer(),
                                        Submitbutton(
                                          name: "I have made this bank transfer",
                                          press: () {
                                            initiate();
                                          },
                                        ),
                                      ],
                                    ),
                                  ):
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                "assets/images/loading${ischange ? "" : "2"}.png",
                                                width: 40,
                                                height: 40,
                                                package: 'flutterduplo',
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Text("Confirming Payment",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 14.62, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text("Expires in 3min 45seconds",
                                          style: GoogleFonts.dmSans(
                                              fontSize: 11.25, fontWeight: FontWeight.w300),
                                        ),
                                        Text("Please do not refresh browser",
                                          style: GoogleFonts.dmSans(
                                              fontSize: 11.25, fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ]
                              ),
                            )
                          ),
                        ],
                      ),
                  );
  }

  _showProcessingError() {
    return !(_paymentError == null || _paymentError!.isEmpty);
  }

  Widget _buildErrorWidget() {
    return ErrorPage(
      charge: _charge,
      text: _paymentError,
      method: CheckoutMethod.bank,
      isCardPayment: _charge.card!.isValid(),
      vSync: this,
      payWithBank: () {
        setState(() {
          _onPaymentError(null);
          _charge.card = PaymentCard.empty();
          _paymentError = null;
        });
      },
      tryAnotherCard: () {
        setState(() {
          _onPaymentError(null);
          _charge.card = PaymentCard.empty();
        });
      },
      startOverWithCard: () {
        _onPaymentError(null);
      },
    );
  }

  Widget _buildSuccessfulWidget() => SuccessfulWidget(
        charge: _charge,
        // amount: _charge.amount,
        onCountdownComplete: () {
          if (_response!.card != null) {
            _response!.card!.nullifyNumber();
          }
          Navigator.of(context).pop(_response);
        },
      );

  Future<void> initiate() async {
    String res;
    startloading();
    setState(() {
      isloading = true;
    });
    res = await verifytransaction(_charge.reference, widget.secretkey);
    var cmddetails = jsonDecode(res);
    setState(() {
      isloading = false;
    });
    if (cmddetails['status']) {
      if (cmddetails['data']["status"] == "pending") {
        dynamic result;
        if(mounted) { // Add this line
          Future.delayed(const Duration(milliseconds: 20000), () {
            result = initiate2();
          });
        }
        return result;
      } else {
        if (cmddetails['data']["status"] == "success") {
          return _onPaymentResponse(CheckoutResponse(
              message: "Payment Success",
              reference: cmddetails['data']["reference"],
              status: true,
              card: _charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false));
        } else {
          return _onPaymentResponse(CheckoutResponse(
              message: "Payment failed",
              reference: cmddetails['data']["reference"],
              status: false,
              card: _charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false));
        }
      }
    } else {
      return _onPaymentResponse(CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false));
      // dispose();
    }

  }

  Future<void> initiate2() async {
    setState(() {
      isloading = true;
    });
    String res;
    res = await verifytransaction(_charge.reference, widget.secretkey);
    var cmddetails = jsonDecode(res);
    setState(() {
      isloading = false;
    });
    if (cmddetails['status']) {
      if (cmddetails['data']["status"] == "pending") {
        dynamic result;
        if(mounted) { // Add this line
          Future.delayed(const Duration(milliseconds: 20000), () {
            result = initiate2();
          });
        }
        return result;
      } else {
        if (cmddetails['data']["status"] == "success") {
          return _onPaymentResponse(CheckoutResponse(
              message: "Payment Success",
              reference: cmddetails['data']["reference"],
              status: true,
              card: _charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false));
        } else {
          return _onPaymentResponse(CheckoutResponse(
              message: "Payment failed",
              reference: cmddetails['data']["reference"],
              status: false,
              card: _charge.card?..nullifyNumber(),
              method: CheckoutMethod.bank,
              verify: false));
        }
      }
    } else {
      return _onPaymentResponse(CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false));
      // dispose();
    }
  }
}
