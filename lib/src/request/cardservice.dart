// Future<CheckoutResponse> cardservice(
//   BuildContext context, {
//   required Charge charge,
//   required String publicKey,
//   required String secretKey,
// }) async {
//   if (charge.currency == "NGN") {
//     String? pin = await showDialog<String>(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) => PinWidget());
//     if (pin != null && pin.length == 4) {
//       charge.card!.pin = pin;
//       return initiate(context,
//           charge: charge, publicKey: publicKey, secretKey: secretKey);
//     } else {
//       return CheckoutResponse(
//           loading: false,
//           message: "cmddetails['message']",
//           reference: charge.reference,
//           status: false,
//           card: charge.card?..nullifyNumber(),
//           method: CheckoutMethod.bank,
//           verify: false);
//       // return notifyProcessingError(
//       //     DuploException("PIN must be exactly 4 digits"));
//     }
//   } else {
//     return initiate(context,
//         charge: charge, publicKey: publicKey, secretKey: secretKey);
//   }
// }

// Future<CheckoutResponse> initiate(
//   BuildContext context, {
//   required Charge charge,
//   required String publicKey,
//   required String secretKey,
// }) async {
//   // List<int> expiryDate = CardUtils.getExpiryDate(expireController.text);
//   //
//   // String _expiryMonth = expiryDate[0].toString();
//   // String _expiryYear = expiryDate[1].toString();
//   String res;
//   // setState(() {
//   //   isLoading = true;
//   // });
//   var iv = charge.reference!.substring(0, 16);
//   var key = publicKey.substring(0, 32);
//   String _expiryMonth = charge.card!.expiryMonth.toString();
//   print(iv);
//   print(key);
//   var card = {
//     "cvv": charge.card!.cvc,
//     "expiryMonth": _expiryMonth.length == 1 ? "0$_expiryMonth" : _expiryMonth,
//     "expiryYear": charge.card!.expiryYear.toString(),
//     "number": charge.card!.number
//   };
//   print("card");
//   print(card);
//   var jsonBody = {
//     "amount": (charge.amount ~/ 100).toString(),
//     "card": encrypt(jsonEncode(card), iv, key),
//     "currency": charge.currency,
//     "email": charge.email,
//     "pin": charge.card!.pin,
//     "reference":
//         charge.reference //"refcard${DateTime.now().microsecondsSinceEpoch}"
//   };
//
//   res = await depositcard(jsonBody, secretKey);
//   // setState(() {
//   //   isLoading = false;
//   // });
//   var cmddetails = jsonDecode(res);
//
//   if (cmddetails['status']) {
//     if (cmddetails['data']['_links']['url'] != null) {
//       if (charge.currency == "NGN") {
//         String? otp = await showDialog<String>(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) => OtpWidget(
//                 // ignore: unnecessary_null_comparison
//                 message: cmddetails['message']));
//         if (otp != null && otp.isNotEmpty) {
//           // return otpinitiate(links, otp, paymentid);
//           // return handleOtpInput(otp, response);
//         } else {
//           return notifyProcessingError(
//               DuploException("You did not provide an OTP"));
//         }
//       } else {
//         String? result = "";
//         TransactionApiResponse apiResponse =
//             TransactionApiResponse.unknownServerResponse();
//
//         Future<void> doit({String? result}) async {
//           try {
//             log(json.decode(result!));
//
//             Map<String, dynamic> responseMap = json.decode(json.decode(result));
//             apiResponse = TransactionApiResponse.fromMap(responseMap);
//           } catch (e) {
//             log(e.toString());
//           }
//         }
//
//         await showDialog(
//             context: context,
//             builder: (_) {
//               // Future
//               return Dialog(
//                 child: Builder(builder: (context) {
//                   return WebView(
//                     url: cmddetails['data']['_links']['url'],
//                   );
//                 }),
//               );
//             }).then((values) async {
//           result = await value();
//           if (result != "") {
//             // await doit(result: result);
//           }
//         }).then((value) async {
//           await doit(result: result);
//         });
//       }
//     }
//     return CheckoutResponse(
//         loading: false,
//         message: cmddetails['message'],
//         reference: charge.reference,
//         status: false,
//         card: charge.card?..nullifyNumber(),
//         method: CheckoutMethod.bank,
//         verify: false);
//   } else {
//     if (cmddetails['message'] != "No internet connection") {
//       return CheckoutResponse(
//           loading: false,
//           message: cmddetails['message'],
//           reference: charge.reference,
//           status: false,
//           card: charge.card?..nullifyNumber(),
//           method: CheckoutMethod.bank,
//           verify: false);
//     }
//   }
// }
