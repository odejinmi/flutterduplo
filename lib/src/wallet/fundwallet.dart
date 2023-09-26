// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutterduplo.dart';
import '../common/utils.dart';
import '../models/checkout_response.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';

class Fundwallet extends StatefulWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse> onResponse;
  final String secretKey;
  final Widget? logo;
  const Fundwallet(
      {Key? key,
      required this.charge,
      this.logo,
      required this.onResponse,
      required this.secretKey})
      : super(key: key);

  @override
  _FundwalletState createState() => _FundwalletState(charge, onResponse);
}

class _FundwalletState extends BaseCheckoutMethodState<Fundwallet> {
  int selected = 1;
  var isLoading = false;
  String ref = "refpay${DateTime.now().microsecondsSinceEpoch}";
  final Charge _charge;
  _FundwalletState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.bank);

  var isloading = false;
  @override
  CheckoutMethod  method = CheckoutMethod.card;
  @override
  Widget buildAnimatedChild() {
    return Center(
            child: Card(
              color: Colors.white,
              elevation: 5.0,
              // borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        height: 60,
                        width: 100,
                        child: widget.logo??Image.asset(
                          'assets/images/logo.png',
                          package: 'flutterduplo',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Pay the amount of",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.63
                      ),),
                    Text(
                      Utils.formatAmount(_charge.amount),
                      style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text("Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 17.63
                            ),),
                          const Spacer(),
                          Text(_charge.email!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 17.63
                            ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/card.png',
                              width: 37,
                              height: 37,
                              package: 'flutterduplo',
                            ),
                            const SizedBox(width: 30,),
                            const Text("Pay with Card"),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xff8E959D), size: 14,)
                          ],
                        ),
                      ),
                      onTap: (){
                        method = CheckoutMethod.card;
                        _charge.method = CheckoutMethod.card;
                        onResponse(CheckoutResponse(
                            message: "loading",
                            reference: _charge.reference,
                            status: false,
                            card: _charge.card?..nullifyNumber(),
                            method: CheckoutMethod.card,
                            verify: false));
                      },
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/transfer.png',
                              width: 37,
                              height: 37,
                              package: 'flutterduplo',
                            ),
                            const SizedBox(width: 30,),
                            const Text("Pay with Bank Transfer"),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xff8E959D), size: 14,)
                          ],
                        ),
                      ),
                      onTap: (){
                        method = CheckoutMethod.bank;
                        _charge.method = CheckoutMethod.bank;
                        onResponse(CheckoutResponse(
                            message: "loading",
                            reference: _charge.reference,
                            status: false,
                            card: _charge.card?..nullifyNumber(),
                            method: CheckoutMethod.bank,
                            verify: false));
                      },
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ussd.png',
                              width: 37,
                              height: 37,
                              package: 'flutterduplo',
                            ),
                            const SizedBox(width: 30,),
                            const Text("Pay with USSD"),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xff8E959D), size: 14,)
                          ],
                        ),
                      ),
                      onTap: (){
                        method = CheckoutMethod.ussd;
                        _charge.method = CheckoutMethod.ussd;
                        onResponse(CheckoutResponse(
                            message: 'loading',
                            reference: _charge.reference,
                            status: false,
                            card: _charge.card?..nullifyNumber(),
                            method: CheckoutMethod.ussd,
                            verify: false));
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

}
