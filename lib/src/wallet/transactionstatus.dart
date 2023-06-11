// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../flutterduplo.dart';
import '../models/checkout_response.dart';
import '../request/apis.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';

class Transactionstatus extends StatefulWidget {
  final Charge charge;
  final bool verify;
  final String secretkey;
  final CheckoutMethod method;
  final OnResponse<CheckoutResponse> onResponse;
  const Transactionstatus(
      {Key? key,
      required this.onResponse,
      required this.charge,
      required this.secretkey,
      required this.method,
      required this.verify})
      : super(key: key);

  @override
  TransactionstatusState createState() =>
      TransactionstatusState(charge, onResponse);
}

class TransactionstatusState
    extends BaseCheckoutMethodState<Transactionstatus> {
  final Charge _charge;
  TransactionstatusState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.bank);
  bool ischange = false;

  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
    if (widget.verify) {
      initiate();
    }
    startloading();
  }

  void initiate() async {
    String res;

    startloading();
    res = await verifytransaction(_charge.reference, widget.secretkey);
    var cmddetails = jsonDecode(res);
    if (cmddetails['status']) {
      onResponse(CheckoutResponse(
          message: cmddetails['message'],
          reference: cmddetails['data']["reference"],
          status: cmddetails['data']["status"] == "success" ? true : false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false));
      // dispose();
    } else {
      onResponse(CheckoutResponse(
          message: cmddetails['message'],
          reference: _charge.reference,
          status: false,
          card: _charge.card?..nullifyNumber(),
          method: CheckoutMethod.bank,
          verify: false));
          // dispose();
    }
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
  void dispose() {
    super.dispose();
    _controller.pause();
  }

  @override
  Widget buildAnimatedChild() {
    return Material(
      color: Colors.white,
      // elevation: 5.0,
      // borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/loading${ischange ? "" : "2"}.png",
                width: 126,
                height: 126,
                package: 'flutterduplo',
              ),
            ),
            Visibility(
              visible: widget.verify,
              child: const Text(
                "Checking transaction status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.method == CheckoutMethod.card?"Processing Card Payment":"Generating Bank Details",
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
