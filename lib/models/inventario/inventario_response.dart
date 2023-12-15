import 'dart:convert';
import 'package:hope_app/models/models.dart';

class InventarioResponse {
    int? code;
    String? status;
    List<Centros>? centrosUsuario;

    InventarioResponse({
        this.code,
        this.status,
        this.centrosUsuario,
    });

    factory InventarioResponse.fromJson(String str) => InventarioResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InventarioResponse.fromMap(Map<String, dynamic> json) => InventarioResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null ? [] : List<Centros>.from(json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null ? [] : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
    };
}