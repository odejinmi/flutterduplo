// const url = "http://10.0.2.2:3030/"; //emulator
// const url = "http://192.168.100.19:3030/"; //local network
import 'package:flutter/foundation.dart';

const url = "https://api.budpay.com/"; //test env
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
