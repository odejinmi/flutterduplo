import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../flutterduplo.dart';
import '../common/utils.dart';
import '../constant/submitbutton.dart';
import '../models/bank.dart';
import '../models/checkout_response.dart';
import '../request/apis.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';
import '../ui/error_widget.dart';
import '../ui/sucessful_widget.dart';
import '../ui/topback.dart';
import 'banklistmodel.dart';
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
  var accountnumber = "";
  var amount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // accountnumber = widget.charge.account!.number!;
    amount = widget.charge.amount;
    ussdban();
  }

  void ussdban() async {
    String res;
    setState(() {
      isloading = true;
    });
    var body_json = {
      "email": _charge.email,
      "amount": _charge.amount.toString(),
      "currency": _charge.currency,
      "reference": _charge.reference,
    };
    res = await ussdinitialize(body_json,widget.secretkey);

    var cmddetails = jsonDecode(res);

    isloading = false;
    if (cmddetails['status']) {
      banks = banklistmodelFromJson(jsonEncode(cmddetails['data']));
      // var response = CheckoutResponse(
      //     message: cmddetails['message'],
      //     reference: _charge.reference,
      //     status: false,
      //     card: _charge.card?..nullifyNumber(),
      //     method: method,
      //     verify: false);
      // // _charge.account ??= BankAccount(
      // //     Bank(cmddetails['data']['bank_name'], 1),
      // //     cmddetails['data']['account_number'],
      // //     cmddetails['data']['account_name']);
      // onResponse(response);
    } else {
      var response = CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false);
      Navigator.pop(context, response);
    }
    setState(() {});
  }
  void ussdbankpayment() async {
    String res;
    setState(() {
      isloading = true;
    });
    var body_json = {
      "bankCode": bankcode,
      "ref": _charge.reference,
    };
    res = await ussdpayment(body_json,widget.secretkey);

    var cmddetails = jsonDecode(res);

    isloading = false;
    if (cmddetails['status']) {
      code = cmddetails['data']['code'];
      setState(() {

      });
    } else {
      var response = CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false);
      Navigator.pop(context, response);
    }
    setState(() {});
  }
  void ussdverifypayment() async {
    String res;
    setState(() {
      isloading = true;
    });
    var body_json = {
      "ref": _charge.reference,
    };
    res = await verifypayment(body_json,widget.secretkey);

    var cmddetails = jsonDecode(res);

    isloading = false;
    if (cmddetails['status']) {
      _charge.account = BankAccount(
          Bank(bankname, 1), "","Ticto Int.");
      var response = CheckoutResponse(
          message: "Payment Success",
          reference:  _charge.reference,
          status: true,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.ussd,
          verify: false);
      return _onPaymentResponse(response);
    } else {
      _charge.account = BankAccount(
          Bank(bankname, 1), "","Ticto Int.");
      var response = CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.ussd,
          verify: false);
      return _onPaymentResponse(response);
    }
    setState(() {});
  }

  bool ischange = false;
  var isloading = false;
  var code = "";
  var bankcode = "";
  var bankname = "";

  var banks = [];

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
                            code.isEmpty?"Please choose your bank to initiate the USSD payment":"Dial the $bankname code generated for you",
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
                                  "assets/images/loading.gif",
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
                                        Text("To complete the payment, please dial the $bankname USSD code provided below on your mobile phone",
                                          style: const TextStyle( fontSize: 12.65, fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 15,),
                                        Text(code, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w700),),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  if (Platform.isAndroid || Platform.isIOS) {
                                                    Uri phoneno = Uri.parse('tel:${Uri.encodeComponent(code)}');
                                                    if (await launchUrl(phoneno)) {
                                                    } else {
                                                      throw 'Could not launch $code';
                                                    }
                                                  }else{
                                                    throw 'Kindly use mobile phone for this feature';
                                                  }
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
                                      ussdverifypayment();
                                    },
                                  ),
                                ],
                              ):
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Select Bank"),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: bankname.isNotEmpty?const Color(
                                        0x1a69ceb8):const Color(0xffF7F9FD),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: bankname.isNotEmpty?const Color(0xff69CEB8): const Color(0xffF7F9FD))
                                ),
                                child: Row(
                                  children: [
                                    Text(bankname.isNotEmpty?bankname:"Select your Bank Name", style:  TextStyle(color: bankname.isNotEmpty?Colors.black:const Color(0xffD9D9DD)),),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: (){
                                          multicountry();
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff575757),))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Submitbutton(
                                buttoncolor: bankname.isEmpty?const Color(0x4069ceb8): const Color(0xff69ceb8),
                                name: "Proceed to Pay ${Utils.formatAmount(_charge.amount)}",
                                press: () {
                                  if (bankname.isNotEmpty) {
                                    ussdbankpayment();
                                  }
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

  void multicountry(){
    showModalBottomSheet(
      context: context,
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20))),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // height: 200,
          child: ListView.builder(
              itemCount: banks.length,
              itemBuilder: (BuildContext context, int index) {
                var bank = banks[index];
                return GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.only(top: 20.0),
                    clipBehavior: Clip.antiAlias,
                    color: const Color(0xffF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          bank.name,
                          style: const TextStyle(
                            // color: xpro,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  onTap: () {
                    bankname = bank.name;
                    bankcode = bank.code;
                    Navigator.pop(context);
                    setState(() {
                    });
                  },
                );
              }),
        );
      },
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
