import 'dart:convert';
import 'package:hope_app/models/models.dart';

class TransferenciasInternasResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;
  List<OrgCompras>? orgCompras;

  TransferenciasInternasResponse({
    this.code,
    this.status,
    this.centrosUsuario,
    this.orgCompras,
  });

  factory TransferenciasInternasResponse.fromJson(String str) =>
      TransferenciasInternasResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferenciasInternasResponse.fromMap(Map<String, dynamic> json) =>
      TransferenciasInternasResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        orgCompras: json["org_compras"] == null
            ? []
            : List<OrgCompras>.from(
                json["org_compras"]!.map((x) => OrgCompras.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "org_compras": orgCompras == null
            ? []
            : List<dynamic>.from(orgCompras!.map((x) => x.toMap())),
      };
}
