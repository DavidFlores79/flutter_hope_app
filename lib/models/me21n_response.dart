// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 23/11/2023
 */

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class ME21NResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;
  List<ClasesDocumento>? clasesDocumento;
  List<OrgCompras>? orgCompras;
  String? gpoCompras;

  ME21NResponse({
    this.code,
    this.status,
    this.centrosUsuario,
    this.clasesDocumento,
    this.orgCompras,
    this.gpoCompras,
  });

  factory ME21NResponse.fromJson(String str) =>
      ME21NResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ME21NResponse.fromMap(Map<String, dynamic> json) => ME21NResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        clasesDocumento: json["clases_documento"] == null
            ? []
            : List<ClasesDocumento>.from(json["clases_documento"]!
                .map((x) => ClasesDocumento.fromMap(x))),
        orgCompras: json["org_compras"] == null
            ? []
            : List<OrgCompras>.from(
                json["org_compras"]!.map((x) => OrgCompras.fromMap(x))),
        gpoCompras: json["gpo_compras"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "clases_documento": clasesDocumento == null
            ? []
            : List<dynamic>.from(clasesDocumento!.map((x) => x.toMap())),
        "org_compras": orgCompras == null
            ? []
            : List<dynamic>.from(orgCompras!.map((x) => x.toMap())),
        "gpo_compras": gpoCompras,
      };
}

class ClasesDocumento {
  int? id;
  String? name;
  String? code;
  bool? status;

  ClasesDocumento({
    this.id,
    this.name,
    this.code,
    this.status,
  });

  factory ClasesDocumento.fromJson(String str) =>
      ClasesDocumento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClasesDocumento.fromMap(Map<String, dynamic> json) => ClasesDocumento(
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
