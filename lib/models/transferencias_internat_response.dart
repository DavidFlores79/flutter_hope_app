import 'dart:convert';
import 'package:hope_app/models/centros.dart';

class TransferenciasInternasResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;

  TransferenciasInternasResponse({
    this.code,
    this.status,
    this.centrosUsuario,
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
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
      };
}
