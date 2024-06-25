// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 08/12/2022
 */

import 'dart:convert';
import 'package:hope_app/models/models.dart';

class SolpedResponse {
  int? code;
  String? status;
  String? message;
  List<Centro>? centrosUsuario;
  List<Posicion>? posiciones;
  ClaseDocumento? claseDocumento;

  SolpedResponse({
    this.code,
    this.status,
    this.message,
    this.centrosUsuario,
    this.posiciones,
    this.claseDocumento,
  });

  factory SolpedResponse.fromJson(String str) =>
      SolpedResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SolpedResponse.fromMap(Map<String, dynamic> json) => SolpedResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centro>.from(
                json["centros_usuario"]!.map((x) => Centro.fromMap(x))),
        posiciones: json["posiciones"] == null
            ? []
            : List<Posicion>.from(
                json["posiciones"]!.map((x) => Posicion.fromMap(x))),
        claseDocumento: json["clase_documento"] == null
            ? null
            : ClaseDocumento.fromMap(json["clase_documento"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "posiciones": posiciones == null
            ? []
            : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
        "clase_documento": claseDocumento?.toMap(),
      };
}
