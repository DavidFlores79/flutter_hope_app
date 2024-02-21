// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 20/02/2024
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class SearchItemsResponse {
  int? code;
  String? status;
  List<SBO_Item>? data;

  SearchItemsResponse({
    this.code,
    this.status,
    this.data,
  });

  factory SearchItemsResponse.fromJson(String str) =>
      SearchItemsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchItemsResponse.fromMap(Map<String, dynamic> json) =>
      SearchItemsResponse(
        code: json["code"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<SBO_Item>.from(
                json["data"]!.map((x) => SBO_Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
