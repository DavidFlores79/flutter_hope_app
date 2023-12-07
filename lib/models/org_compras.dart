// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 05/12/2023
 */
import 'dart:convert';

class OrgCompras {
  int? id;
  String? name;
  String? code;
  bool? status;

  OrgCompras({
    this.id,
    this.name,
    this.code,
    this.status,
  });

  factory OrgCompras.fromJson(String str) =>
      OrgCompras.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgCompras.fromMap(Map<String, dynamic> json) => OrgCompras(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
      };
}