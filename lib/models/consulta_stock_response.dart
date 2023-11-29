import 'dart:convert';
import 'package:hope_app/models/centros.dart';

class ConsultaStockResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;

  ConsultaStockResponse({
    this.code,
    this.status,
    this.centrosUsuario,
  });

  factory ConsultaStockResponse.fromJson(String str) =>
      ConsultaStockResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsultaStockResponse.fromMap(Map<String, dynamic> json) =>
      ConsultaStockResponse(
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
