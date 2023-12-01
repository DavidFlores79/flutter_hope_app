import 'dart:convert';
import 'package:hope_app/models/centros.dart';

class ReciboEmbarqueResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;

  ReciboEmbarqueResponse({
    this.code,
    this.status,
    this.centrosUsuario,
  });

  factory ReciboEmbarqueResponse.fromJson(String str) =>
      ReciboEmbarqueResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReciboEmbarqueResponse.fromMap(Map<String, dynamic> json) =>
      ReciboEmbarqueResponse(
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

