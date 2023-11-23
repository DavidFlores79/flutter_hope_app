import 'dart:convert';

import 'package:hope_app/models/models.dart';

class BuscarSolpedsResponse {
  int? code;
  String? status;
  String? message;
  List<Posicion>? pedidos;

  BuscarSolpedsResponse({
    this.code,
    this.status,
    this.message,
    this.pedidos,
  });

  factory BuscarSolpedsResponse.fromJson(String str) =>
      BuscarSolpedsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuscarSolpedsResponse.fromMap(Map<String, dynamic> json) =>
      BuscarSolpedsResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        pedidos: json["pedidos"] == null
            ? []
            : List<Posicion>.from(
                json["pedidos"]!.map((x) => Posicion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "pedidos": pedidos == null
            ? []
            : List<dynamic>.from(pedidos!.map((x) => x.toMap())),
      };
}
