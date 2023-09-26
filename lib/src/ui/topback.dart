import 'package:flutter/material.dart';

import '../../flutterduplo.dart';
import '../models/checkout_response.dart';
import 'checkout/checkout_widget.dart';

class Topback extends StatelessWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse>? onResponse;
  final Function? press;
  final Widget? logo;

  const Topback({Key? key, required this.charge,this.onResponse, this.press, this.logo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Image.asset(
            'assets/images/backarrow.png',
            height: 30,
            width: 30,
            package: 'flutterduplo',
          ),
          onTap: (){
            if (onResponse != null) {
              onResponse!(CheckoutResponse(
                  message: "loading",
                  reference: charge.reference,
                  status: false,
                  card: charge.card?..nullifyNumber(),
                  method: CheckoutMethod.selectable,
                  verify: false));
            }else{
              press!();
            }
          },
        ),
        const SizedBox(width: 10,),
        const Text("Change Payment Method", style: TextStyle(fontSize: 10.25, fontWeight: FontWeight.w400),),
        const Spacer(),
        Container(
          height: 50,
          width: 50,
          child: logo??Image.asset(
            'assets/images/logo.png',
            package: 'flutterduplo',
          ),
        ),
      ],
    );
  }
}
