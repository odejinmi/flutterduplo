// import 'package:flutter/foundation.dart';
// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutterduplo/src/ui/topback.dart';
import 'package:flutterduplo/src/wallet/transactionstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutterduplo.dart';
import '../api/transaction/cardtransactionmanager.dart';
import '../common/card_utils.dart';
import '../common/utils.dart';
import '../constant/constant.dart';
import '../constant/submitbutton.dart';
// import '../models/card.dart';
// import '../models/charge.dart';
import '../models/checkout_response.dart';
import '../ui/checkout/base_checkout.dart';
import '../ui/checkout/checkout_widget.dart';
import '../ui/error_widget.dart';
import '../ui/input/cvc_field.dart';
import '../ui/input/date_field.dart';
import '../ui/input/number_field.dart';
import '../ui/pin_widget.dart';
import '../ui/sucessful_widget.dart';

class Debitcard extends StatefulWidget {
  final Charge charge;
  final OnResponse<CheckoutResponse> onResponse;
  final String publicKey, secretKey;
  const Debitcard({
    Key? key,
    required this.charge,
    required this.onResponse,
    required this.publicKey,
    required this.secretKey,
  }) : super(key: key);

  @override
  _DebitcardState createState() => _DebitcardState(charge, onResponse);
}

class _DebitcardState extends BaseCheckoutMethodState<Debitcard> {
  final Charge _charge;
  _DebitcardState(this._charge, OnResponse<CheckoutResponse> onResponse)
      : super(onResponse, CheckoutMethod.bank);
  TextEditingController expireController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  TextEditingController numberController = TextEditingController();
  int selected = 1;
  PaymentCard? _card;
  var isLoading = false;
  var isverify = false;
  var ispinned = false;

  @override
  void initState() {
    _card = PaymentCard(
      number: "",
      cvc: "",
      expiryMonth: "",
      expiryYear: "",
    );
    numberController.addListener(_getCardTypeFrmNumber);
    if (_card?.number != null) {
      numberController.text = Utils.addSpaces(_card!.number!);
    }
    super.initState();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    String cardType = _card!.getTypeForIIN(input);
    setState(() {
      _card!.type = cardType;
    });
  }

  @override
  void dispose() {
    super.dispose();
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
  }

  Widget getCardIcon() {
    String img = "";
    var defaultIcon = Icon(
      Icons.credit_card,
      key: const Key("DefaultIssuerIcon"),
      size: 15.0,
      color: Colors.grey[600],
    );
    if (_card != null) {
      switch (_card!.type) {
        case CardType.masterCard:
          img = 'mastercard.png';
          break;
        case CardType.visa:
          img = 'visa.png';
          break;
        case CardType.verve:
          img = 'verve.png';
          break;
        case CardType.americanExpress:
          img = 'american_express.png';
          break;
        case CardType.discover:
          img = 'discover.png';
          break;
        case CardType.dinersClub:
          img = 'dinners_club.png';
          break;
        case CardType.jcb:
          img = 'jcb.png';
          break;
      }
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        key: const Key("IssuerIcon"),
        height: 15,
        width: 30,
        package: 'flutterduplo',
      );
    } else {
      widget = defaultIcon;
    }
    return widget;
  }

  @override
  Widget buildAnimatedChild() {
    return _showProcessingError()
    ? _buildErrorWidget()
        : _paymentSuccessful
    ? _buildSuccessfulWidget()
        :Material(
            color: Colors.white,
            // elevation: 5.0,
            // borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isLoading
                  ? Material(
                    color: Colors.white,
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(5),
                    child: Transactionstatus(
                      method: CheckoutMethod.card,
                charge: _charge,
                secretkey: widget.secretKey,
                verify: isverify,
                // service: widget.bankService,
                onResponse: _onPaymentResponse,
              ),
                  )
                  : Column(
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
                      Material(
                        color: Colors.white,
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Topback(charge: _charge, onResponse: onResponse),
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
                            ispinned?PinWidget(onpress: (pin){
                              _charge.card!.pin = pin;
                              isLoading = true;
                              setState(() {

                              });
                              chargecard();
                              },):
                            Column(
                              children: [
                                const SizedBox(height: 30,),
                                const Text("Pay with Card", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
                                const Text("Enter your card information", style: TextStyle(fontSize: 14.65, fontWeight: FontWeight.w400),),
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "Card Number",
                                  style: GoogleFonts.dmSans(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                NumberField(
                                  key: const Key("CardNumberKey"),
                                  controller: numberController,
                                  card: _card,
                                  onSaved: (String? value) {
                                    setState(() {
                                      _card!.number =
                                          CardUtils.getCleanedNumber(value);
                                    });
                                  },
                                  suffix: getCardIcon(),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Expiry Date",
                                            style: GoogleFonts.dmSans(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          DateField(
                                            controller: expireController,
                                            key: const ValueKey("ExpiryKey"),
                                            card: _card,
                                            onSaved: (value) {
                                              setState(() {
                                                List<int> expiryDate =
                                                CardUtils.getExpiryDate(value);
                                                _card!.expiryMonth = expiryDate[0];
                                                _card!.expiryYear = expiryDate[1];
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "CVV",
                                              style: GoogleFonts.dmSans(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CVCField(
                                              controller: cvvController,
                                              key: const Key("CVVKey"),
                                              card: _card,
                                              onSaved: (value) {
                                                setState(() {
                                                  _card!.cvc =
                                                      CardUtils.getCleanedNumber(value);
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Submitbutton(
                                    name: "Pay ${Utils.formatAmount(_charge.amount)}",
                                    press: () async {
                                      List<int> expiryDate = CardUtils.getExpiryDate(
                                          expireController.text);
                                        _charge.card!.number =
                                            CardUtils.getCleanedNumber(
                                                numberController.text);
                                      _charge.card!.type = _card!.type;
                                      _charge.method = CheckoutMethod.card;
                                        _charge.card!.expiryMonth = expiryDate[0];
                                        _charge.card!.expiryYear = expiryDate[1];
                                        _charge.card!.cvc = cvvController.text;
                                      if (_charge.currency == "NGN") {
                                        ispinned = true;
                                      }else{
                                        isLoading = true;
                                        chargecard();
                                      }
                                      setState(() {

                                      });
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          );
  }

  Future<void> chargecard() async {
    final response = await CardTransactionManager(
        context: context,
        publicKey: widget.publicKey,
        secretKey: widget.secretKey,
        charge: _charge)
        .cardservice();
    _onPaymentResponse(response);
  }
  CheckoutResponse? _response;
  void _onPaymentResponse(CheckoutResponse response) {
    // print(response);
    _response = response;
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (response.status == true) {
      _onPaymentSuccess();
    } else {
      _onPaymentError(response.message);
    }
    //
    // if (response.loading && response.method == CheckoutMethod.bank) {
    //   initiate();
    // }
  }

  String? _paymentError;
  bool _paymentSuccessful = false;
  void _onProcessingChange(bool processing) {
    setState(() {
      processing = processing;
    });
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
          ispinned = false;
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
        // amount: _charge.amount,
        charge: _charge,
        onCountdownComplete: () {
          if (_response!.card != null) {
            _response!.card!.nullifyNumber();
          }
          Navigator.of(context).pop(_response);
        },
      );
}
