import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutterduplo.dart';
import '../common/utils.dart';
import '../constant/submitbutton.dart';
import '../models/checkout_response.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';
import '../ui/error_widget.dart';
import '../ui/sucessful_widget.dart';
import '../ui/topback.dart';
import 'copy.dart';

class Ussd extends StatefulWidget {
  final Charge charge;
  final String secretkey, publickey;
  final OnResponse<CheckoutResponse> onResponse;
  const Ussd({Key? key,
    required this.charge,
    required this.secretkey,
    required this.publickey,
    required this.onResponse}) : super(key: key);

  @override
  UssdState createState() => UssdState(charge, onResponse);
}

class UssdState extends BaseCheckoutMethodState<Ussd> {
  final Charge _charge;
  UssdState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.ussd);


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
  var code = "";

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
        isloading = false;
        startloading();
        code = "*894*000*7857";
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
                            "Pay with USSD",
                            style: GoogleFonts.dmSans(
                                fontSize: 22.14, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            code.isEmpty?"Please choose your bank to initiate the USSD payment":"Dial the First Bank code generated for you",
                            style: GoogleFonts.dmSans(
                                fontSize: 11.07, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          isloading?Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/loading${ischange ? "" : "2"}.png",
                                  width: 80,
                                  height: 80,
                                  package: 'flutterduplo',
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text("Generating USSD Code",
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.55, fontWeight: FontWeight.w600, color: const Color(0xff4C4C4C)),
                              ),
                              const SizedBox(height: 80,)
                            ],
                          ) :code.isNotEmpty?
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Color(0xffF7F9FD)
                                    ),
                                    child: Column(
                                      children: [
                                        const Text("To complete the payment, please dial the First Bank USSD code provided below on your mobile phone",
                                          style: TextStyle( fontSize: 12.65, fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 15,),
                                        Text(code, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w700),),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () {

                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xff69CEB8),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.local_phone_outlined,
                                                        size: 9.11,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        "DIAL",
                                                        style: TextStyle(fontSize: 7.59, color: Colors.white, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                            const SizedBox(width: 10,),
                                            Copy(quote: code)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  Submitbutton(
                                    name: "I have dial the USSD Code",
                                    press: () {
                                      startloading();
                                      setState(() {
                                        isloading = true;
                                      });
                                    },
                                  ),
                                ],
                              ):
                          Column(
                            children: [
                              const Text("Select Bank"),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                decoration: const BoxDecoration(
                                    color: Color(0xffF7F9FD),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Row(
                                  children: [
                                    const Text("Select your Bank Name", style: TextStyle(color: Color(0xffD9D9DD)),),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: (){},
                                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff575757),))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Submitbutton(
                                buttoncolor: const Color(0x4069ceb8),
                                name: "Proceed to Pay ${Utils.formatAmount(_charge.amount)}",
                                press: () {
                                  startloading();
                                  setState(() {
                                    isloading = true;
                                  });
                                },
                              ),
                            ],
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

  @override
  getPopReturnValue() {
    return _getResponse();
  }

  CheckoutResponse _getResponse() {
    CheckoutResponse? response = _response;
    if (response == null) {
      response = CheckoutResponse.defaults();
      response.method = CheckoutMethod.ussd;
    }
    if (response.card != null) {
      response.card!.nullifyNumber();
    }
    return response;
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
}
