// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, unused_field

import 'package:flutter/material.dart';

import '../../../flutterduplo.dart';
import '../../common/my_strings.dart';
import '../../models/checkout_response.dart';
import 'base_checkout.dart';
import 'checkout_widget.dart';

class CardCheckout extends StatefulWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse> onResponse;
  final ValueChanged<bool> onProcessingChange;
  final ValueChanged<PaymentCard?> onCardChange;
  final bool hideAmount;
  // final CardServiceContract transaction;
  final String publicKey, secretKey;

  const CardCheckout({
    Key? key,
    required this.charge,
    required this.onResponse,
    required this.onProcessingChange,
    required this.onCardChange,
    // required this.transaction,
    required this.publicKey,
    required this.secretKey,
    this.hideAmount = false,
  }) : super(key: key);

  @override
  _CardCheckoutState createState() => _CardCheckoutState(charge, onResponse);
}

class _CardCheckoutState extends BaseCheckoutMethodState<CardCheckout> {
  final Charge _charge;

  _CardCheckoutState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.card);

  @override
  Widget buildAnimatedChild() {
    // var amountText =
    //     _charge.amount.isNegative ? '' : Utils.formatAmount(_charge.amount);

    return Container(
      alignment: Alignment.center,
      child: const Column(
        children: <Widget>[
          Text(
            Strings.cardInputInstruction,
            key: Key("InstructionKey"),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20.0,
          ),
          // CardInput(
          //   key: const Key("CardInput"),
          //   buttonText: widget.hideAmount ? "Continue" : 'Pay $amountText',
          //   card: _charge.card,
          //   onValidated: _onCardValidated,
          // ),
        ],
      ),
    );
  }

  // void _onCardValidated(PaymentCard? card) {
  //   if (card == null) return;
  //   _charge.card = card;
  //   widget.onCardChange(_charge.card);
  //   widget.onProcessingChange(true);

  //   if (_charge.reference != null && _charge.reference!.isNotEmpty) {
  //     if (_charge.reference!.length >= 16) {
  //       _chargeCard(_charge);
  //     } else {
  //       // This should never happen. Validation has already been done in [DuploPayment .checkout]
  //       throw ChargeException('reference should be atleast 16 digit');
  //     }
  //   } else {
  //     // This should never happen. Validation has already been done in [DuploPayment .checkout]
  //     throw ChargeException(Strings.noAccessCodeReference);
  //   }
  // }

  // void _chargeCard(Charge charge) async {
  //   if (kDebugMode) {
  //     print(charge.card!.last4Digits);
  //   }
  //   if (kDebugMode) {
  //     print(charge.card!.number);
  //   }
  //   // CardTransactionManager(
  //   //         context: context,
  //   //         publicKey: widget.publicKey,
  //   //         secretKey: widget.secretKey,
  //   //         charge: charge)
  //   //     .cardservice();
  //   // final response = await CardTransactionManager(
  //   //   charge: charge,
  //   //   context: context,
  //   //   // transaction: widget.transaction,
  //   //   publicKey: widget.publicKey,
  //   // ).chargeCard();
  //   // onResponse(response);
  // }
}
