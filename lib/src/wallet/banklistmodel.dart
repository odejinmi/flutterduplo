// To parse this JSON data, do
//
//     final banklistmodel = banklistmodelFromJson(jsonString);

import 'dart:convert';

List<Banklistmodel> banklistmodelFromJson(String str) => List<Banklistmodel>.from(json.decode(str).map((x) => Banklistmodel.fromJson(x)));

String banklistmodelToJson(List<Banklistmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Banklistmodel {
  String name;
  String code;
  String cbnCode;

  Banklistmodel({
    required this.name,
    required this.code,
    required this.cbnCode,
  });

  factory Banklistmodel.fromJson(Map<String, dynamic> json) => Banklistmodel(
    name: json["name"],
    code: json["code"],
    cbnCode: json["cbnCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "cbnCode": cbnCode,
  };
}
