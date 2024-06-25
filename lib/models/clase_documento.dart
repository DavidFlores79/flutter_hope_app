// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 24/06/2024
 */
import 'dart:convert';

class ClaseDocumento {
  String? code;
  String? label;

  ClaseDocumento({
    this.code,
    this.label,
  });

  factory ClaseDocumento.fromJson(String str) =>
      ClaseDocumento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClaseDocumento.fromMap(Map<String, dynamic> json) => ClaseDocumento(
        code: json["code"],
        label: json["label"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "label": label,
      };
}
