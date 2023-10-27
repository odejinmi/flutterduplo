// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'env_variable.dart';

var onFailure = '{"success":false,"message":"No internet connection"}';

Future<String> postApiCallTokenized(jsonBody, endpoint, secretKey) async {
  var res = onFailure;

  if (debug) {
    if (kDebugMode) {
      print(jsonBody);
    }
  }

  try {
    http.Response response = await http.post(
        endpoint.toString().startsWith("i")?parseURL2(endpoint,secretKey):parseURL(endpoint,secretKey),
        body: jsonBody,
        headers: {HttpHeaders.authorizationHeader: "Bearer $secretKey"});
    res = response.body;
    if (debug) {
      if (kDebugMode) {
        print("method: $res");
      }
    }
  } catch (Exception) {
    // nonetwork();

    if (debug) {
      if (kDebugMode) {
        print(Exception);
      }
    }
  }
  return res;
}

Future<String> getApiCallTokenized(endpoint, publicKey) async {
  var res = onFailure;
  try {
    http.Response response = await http.get(
        endpoint.toString().startsWith("i")?parseURL2(endpoint,publicKey):parseURL(endpoint,publicKey), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $publicKey"
    });

    res = response.body;
    if (debug) {
      if (kDebugMode) {
        print("method: $res");
      }
    }
  } catch (Exception) {
    if (debug) {
      if (kDebugMode) {
        print(Exception);
      }
    }
  }
  return res;
}
