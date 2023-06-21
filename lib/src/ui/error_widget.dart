import 'package:flutter/material.dart';
import 'package:flutterduplo/src/ui/statuswidget.dart';

import '../../flutterduplo.dart';
import '../common/card_utils.dart';
import '../common/utils.dart';
import 'animated_widget.dart';
import 'buttons.dart';

class ErrorPage extends StatelessWidget {
  final TickerProvider vSync;
  final AnimationController controller;
  final CheckoutMethod method;
  final Charge charge;
  final String? text;
  final VoidCallback? payWithBank;
  final VoidCallback? tryAnotherCard;
  final VoidCallback? startOverWithCard;
  final bool isCardPayment;

  ErrorPage({
    Key? key,
    required this.text,
    required this.vSync,
    required this.method,
    required this.charge,
    required this.isCardPayment,
    this.payWithBank,
    this.tryAnotherCard,
    this.startOverWithCard,
  })  : controller = AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: vSync,
        ),
        super(key: key) {
    controller.forward();
  }

  final emptyContainer = Container();

  @override
  Widget build(BuildContext context) {
    // Remove 'Retry buttons for bank payment because when you retry a transaction it ret
    var buttonMargin =
        isCardPayment ? const SizedBox(height: 5.0) : emptyContainer;
    return Material(
      color: const Color(0xffF5F5F5),
      // elevation: 5.0,
      // borderRadius: BorderRadius.circular(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: payWithBank,
              child: const Text("TRY AGAIN",
                style: TextStyle(
                    fontSize: 16.36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEB001B)
                ),),
            ),
          ),
          Statuswidget(
            title: "Payment Failed",
            image: 'assets/images/errorbutton.png',
              charge: charge)

          // isCardPayment
          //     ? WhiteButton(onPressed: tryAnotherCard, text: 'Try another card')
          //     : emptyContainer,
          // buttonMargin,
          // method == CheckoutMethod.selectable || method == CheckoutMethod.bank
          //     ? WhiteButton(
          //   onPressed: payWithBank,
          //   text: method == CheckoutMethod.bank || !isCardPayment
          //       ? 'Retry'
          //       : 'Try paying with your bank account',
          // )
          //     : emptyContainer,
          // buttonMargin,
          // isCardPayment
          //     ? WhiteButton(
          //   onPressed: startOverWithCard,
          //   text: 'Start over with same card',
          //   iconData: Icons.refresh,
          //   bold: false,
          //   flat: true,
          // )
          //     : emptyContainer
        ],
      ),
    );
  }
}
