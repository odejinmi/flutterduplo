import 'package:flutter/material.dart';

import '../../flutterduplo.dart';
import '../common/utils.dart';

class Statuswidget extends StatelessWidget {
  final Charge charge;
  final String image, title;
  const Statuswidget({Key? key, required this.charge, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String method = "";
    switch (charge.method) {
    case CheckoutMethod.bank:
    method = "Bank Transfer";
    break;
    case CheckoutMethod.card:
    method = "Card";
    break;
    case CheckoutMethod.ussd:
    method = "Ussd";
    break;
    default:
      method = "Ussd";
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Material(
            color: Colors.white,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              child: Column(
                children: [
                  Image.asset(image,
                    height: 50,
                    width: 50,
                    package: 'flutterduplo',
                  ),
                  Text(
                    Utils.formatAmount(charge.amount), style: const TextStyle(fontSize: 40.4, fontWeight: FontWeight.w600),),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),

                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Material(
            color: Colors.white,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(20))
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Payment Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 25,),
                  Row(
                    children: [
                      const Text("Reference", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                      const SizedBox(width: 20,),
                      Expanded(child: Text(charge.reference!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.right,)),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  Row(
                    children: [
                      Text("Payment Method", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                      Spacer(),
                      Text(method, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  charge.method == CheckoutMethod.card? Column(
                    children: [
                      Row(
                        children: [
                          const Text("Card Issuer", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                          const Spacer(),
                          getCardIcon(),
                          const SizedBox(width: 5,),
                          Text(charge.card!.type!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Row(
                        children: [
                          const Text("Ending with", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                          const Spacer(),
                          Text("**** **** **** ", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ],
                  ): Column(
                    children: [
                      Row(
                        children: [
                          const Text("Account Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                          const Spacer(),
                          Text(charge.account!.name!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Row(
                        children: [
                          const Text("Bank Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                          const Spacer(),
                          Text(charge.account!.bank!.name!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  const Row(
                    children: [
                      Text("Payment Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                      Spacer(),
                      Text("Feb 06, 2023 02:24PM", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Material(
            color: Colors.white,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/document.png',
                    height: 15,
                    width: 30,
                    package: 'flutterduplo',
                  ),
                  const Text("Download Receipt", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ),

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

  Widget getCardIcon() {
    String img = "";
    var defaultIcon = Icon(
      Icons.credit_card,
      key: const Key("DefaultIssuerIcon"),
      size: 15.0,
      color: Colors.grey[600],
    );
    switch (charge.card!.type!) {
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
}
