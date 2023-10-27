import 'package:flutter/foundation.dart';

const liveurl = "https://api.duplopg.com/"; //live env
const url = "https://api.stag.duplopg.com/"; //test env
const imageurl =
    "https://budmall.staging.5starcompany.com.ng/assets/images/"; //test env

const debug = true;

// String? token;

var abitID = "";
var token = "";

String baseurl(secretKey){
  print("secretKey");
  print(secretKey);
  // return secretKey.split('_')[1] == "test"?url:liveurl;
  // return secretKey.startsWith("sk_test")?url:liveurl;
  return liveurl;
}
parseURL(uri,secretKey) {
  var uu = Uri.parse("${baseurl(secretKey)}api/s2s/$uri");
  if (kDebugMode) {
    print(uu);
  }
  return uu;
}
parseURL2(uri,publicKey) {
  var uu = Uri.parse("${baseurl(publicKey)}api/$uri");
  if (kDebugMode) {
    print(uu);
  }
  return uu;
}
