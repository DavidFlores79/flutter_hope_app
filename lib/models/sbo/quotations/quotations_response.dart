// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 28/02/2024
 */
import 'dart:convert';

class QuotationsResponse {
  int? code;
  String? status;
  String? message;

  QuotationsResponse({
    this.code,
    this.status,
    this.message,
  });

  factory QuotationsResponse.fromJson(String str) =>
      QuotationsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuotationsResponse.fromMap(Map<String, dynamic> json) =>
      QuotationsResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
      };
}
