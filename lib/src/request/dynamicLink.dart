// ignore_for_file: file_names
// Future<String> createDynamicLink(bool short, String ID, String Image,
//     String Name, String Description) async {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://tatspace.page.link',
//     link: Uri.parse('https://abitpay.app/products?product=${ID}'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.abitnetwork.abitpay',
//       minimumVersion: 0,
//     ),
//     // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//     //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//     // ),
//     iosParameters: IOSParameters(
//       bundleId: 'com.abitnetwork.abitpay',
//       minimumVersion: '0',
//     ),
//     googleAnalyticsParameters: GoogleAnalyticsParameters(
//       campaign: 'product',
//       medium: 'social',
//       source: 'abitpayapp',
//     ),
//     socialMetaTagParameters: SocialMetaTagParameters(
//         title: '${Name} on ABiTShopper',
//         description: '${Description}',
//         imageUrl: Uri.parse("${Image}")),
//   );
//
//   Uri url;
//   if (short) {
//     final ShortDynamicLink shortLink =
//         await dynamicLinks.buildShortLink(parameters);
//     url = shortLink.shortUrl;
//   } else {
//     url = await dynamicLinks.buildLink(parameters);
//   }
//
//   return url.toString();
//
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   // prefs.setString('referrallink', url.toString());
//   //
//   // setState(() {
//   //   _linkMessage = url.toString();
//   //   quote = quote + url.toString();
//   //   _isCreatingLink = false;
//   // });
// }
//
// Future<void> initDynamicLinksOps(context) async {
//   FirebaseDynamicLinks.instance.onLink;
//
//   //when app is not opened
//   final PendingDynamicLinkData data =
//       await FirebaseDynamicLinks.instance.getInitialLink();
//   final Uri deepLink = data?.link;
//
//   if (deepLink != null) {
//     // ignore: unawaited_futures
//     linkCategory(deepLink, context);
//   }
// }
//
// void linkCategory(deepLink, context) {
//   if (deepLink.queryParameters.containsKey('referral')) {
//     signUp(deepLink, context);
//   }
//
//   if (deepLink.queryParameters.containsKey('product')) {
//     product(deepLink, context);
//   }
// }
//
// void signUp(deepLink, context) {
//   String referral = deepLink.queryParameters['referral'];
//   print("referral");
//   print(referral);
//
//   Navigator.of(context).pushReplacement(MaterialPageRoute(
//     builder: (BuildContext context) => Signup(referral: referral),
//   ));
// }
//
// Future<void> product(deepLink, context) async {
//   String productID = deepLink.queryParameters['product'];
//   print("product");
//   print(productID);
//
//   String res = await getProduct(productID, context);
//
//   var cmddetails = jsonDecode(res);
//
//   if (cmddetails['success']) {
//     print(cmddetails['data']);
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (BuildContext context) => Buypage(
//         id: productID,
//       ),
//     ));
//   } else {
//     if (cmddetails['message'] != "No internet connection") {
//       showCommonError(cmddetails['message']);
//     }
//   }
// }
