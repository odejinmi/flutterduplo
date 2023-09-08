import 'package:flutter/foundation.dart';

const url = "https://api.duplopg.com/"; //live env
const testurl = "https://api.stag.duplopg.com/"; //test env
const imageurl =
    "https://budmall.staging.5starcompany.com.ng/assets/images/"; //test env

const debug = true;

// String? token;

var abitID = "";
var token = "";

parseURL(uri) {
  var uu = Uri.parse("${url}api/s2s/$uri");
  if (kDebugMode) {
    print(uu);
  }
  return uu;
}
parseURL2(uri) {
  var uu = Uri.parse("${url}api/$uri");
  if (kDebugMode) {
    print(uu);
  }
  return uu;
}
