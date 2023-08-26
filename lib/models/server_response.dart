// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 22/11/2022
 */

import 'dart:convert';

class ServerResponse {
  ServerResponse({
    this.code,
    this.status,
    this.message,
    this.success,
  });

  int? code;
  String? status;
  String? message;
  bool? success;

  factory ServerResponse.fromJson(String str) =>
      ServerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServerResponse.fromMap(Map<String, dynamic> json) => ServerResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "success": success,
      };
}

class ValidatorResponse {
  ValidatorResponse({
    required this.message,
    required this.errors,
  });

  String message;
  Errors errors;

  factory ValidatorResponse.fromJson(String str) =>
      ValidatorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ValidatorResponse.fromMap(Map<String, dynamic> json) =>
      ValidatorResponse(
        message: json["message"],
        errors: Errors.fromMap(json["errors"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "errors": errors.toMap(),
      };
}

class Errors {
  Errors({
    this.pedidos,
    this.proveedor,
  });

  List<String>? pedidos;
  List<String>? proveedor;

  factory Errors.fromJson(String str) => Errors.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Errors.fromMap(Map<String, dynamic> json) => Errors(
        pedidos: List<String>.from(json["pedidos"].map((x) => x)),
        proveedor: List<String>.from(json["proveedor"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "pedidos": List<dynamic>.from(pedidos!.map((x) => x)),
        "proveedor": List<dynamic>.from(proveedor!.map((x) => x)),
      };
}

class UnauthenticatedResponse {
  UnauthenticatedResponse({
    required this.message,
  });

  String message;

  factory UnauthenticatedResponse.fromJson(String str) =>
      UnauthenticatedResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnauthenticatedResponse.fromMap(Map<String, dynamic> json) =>
      UnauthenticatedResponse(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
