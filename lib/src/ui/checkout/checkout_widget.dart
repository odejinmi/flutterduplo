// import 'package:expandable/expandable.dart';
// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutterduplo/src/wallet/banktransfer.dart';
import 'package:flutterduplo/src/wallet/debitcard.dart';
import 'package:flutterduplo/src/wallet/fundwallet.dart';
import 'package:flutterduplo/src/wallet/ussd.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../flutterduplo.dart';
import '../../common/utils.dart';
import '../../models/checkout_response.dart';
import '../base_widget.dart';
// import '../custom_dialog.dart';
// import '../error_widget.dart';
// import '../sucessful_widget.dart';
import '../custom_dialog.dart';

const kFullTabHeight = 74.0;

class CheckoutWidget extends StatefulWidget {
  final Charge charge;
  // final bool fullscreen;
  final Widget? logo;
  final bool hideEmail;
  final bool hideAmount;
  // final BankServiceContract bankService;
  // final CardServiceContract cardsService;
  final String publicKey;
  final String secretKey;

  const CheckoutWidget({
    Key? key,
    required this.charge,
    // required this.bankService,
    // required this.cardsService,
    required this.publicKey,
    required this.secretKey,
    // this.fullscreen = false,
    this.logo,
    this.hideEmail = false,
    this.hideAmount = false,
  }) : super(key: key);

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState(charge);
}

class _CheckoutWidgetState extends BaseState<CheckoutWidget>
    with TickerProviderStateMixin {
  static const tabBorderRadius = BorderRadius.all(Radius.circular(4.0));
  final Charge _charge;
  String? _paymentError;
  bool _iscard = false;
  bool _isbank = false;
  bool _isussd = false;
  CheckoutMethod method = CheckoutMethod.selectable;
  late AnimationController _animationController;
  CheckoutResponse? _response;
  var controller1, controller2;
  _CheckoutWidgetState(this._charge);

  @override
  void initState() {
    super.initState();
    if (_charge.currency != "NGN") {
      _iscard = true;
    }
    _init();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _charge.card ??= PaymentCard.empty();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
      expanded: true,
      titlePadding: const EdgeInsets.all(0.0),
      onCancelPress: onCancelPress,
      content: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _iscard
                      ? Debitcard(
                          secretKey: widget.secretKey,
                          publicKey: widget.publicKey,
                          charge: _charge,
                          onResponse: _onPaymentResponse,
                        )
                      : _isbank
                          ? Banktransfer(
                              secretkey: widget.secretKey,
                              publickey: widget.publicKey,
                              charge: _charge,
                              onResponse: _onPaymentResponse,
                            )
                          : _isussd
                          ? Ussd(
                              secretkey: widget.secretKey,
                              publickey: widget.publicKey,
                              charge: _charge,
                              onResponse: _onPaymentResponse,
                            )
                          : Fundwallet(
                              secretKey: widget.secretKey,
                              charge: _charge,
                              onResponse: _onPaymentResponse,
                            ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Powered by',
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400, fontSize: 16.36),
                        ),
                        const SizedBox(width: 7,),
                        Image.asset(
                          'assets/images/duplo.png',
                          width: 70,
                          height: 24,
                          package: 'flutterduplo',
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _onPaymentResponse(CheckoutResponse response) {
    _response = response;
    if (!mounted) return;
    setState(() {
      if (response.method == CheckoutMethod.bank) {
        _isbank = true;
        _iscard = false;
        _isussd = false;
      } else if (response.method == CheckoutMethod.ussd) {
        _isussd = true;
        _isbank = false;
        _iscard = false;
      } else if (response.method == CheckoutMethod.selectable) {
        _isbank = false;
        _iscard = false;
        _isussd = false;
      } else {
        _iscard = true;
        _isbank = false;
        _isussd = false;
      }
    });
  }

  @override
  getPopReturnValue() {
    return _getResponse();
  }

  CheckoutResponse _getResponse() {
    CheckoutResponse? response = _response;
    if (response == null) {
      response = CheckoutResponse.defaults();
      response.method = method;
    }
    if (response.card != null) {
      response.card!.nullifyNumber();
    }
    return response;
  }

  _init() {
    Utils.setCurrencyFormatter(_charge.currency, _charge.locale);
  }
}

typedef OnResponse<CheckoutResponse> = void Function(CheckoutResponse response);
