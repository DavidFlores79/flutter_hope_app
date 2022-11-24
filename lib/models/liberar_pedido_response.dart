// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 22/11/2022
 */

import 'dart:convert';

class LiberarPedidoResponse {
  LiberarPedidoResponse({
    required this.code,
    required this.status,
    required this.success,
    required this.message,
    this.pedidoLiberado,
  });

  int code;
  String status;
  bool success;
  String message;
  PedidoLiberado? pedidoLiberado;

  factory LiberarPedidoResponse.fromJson(String str) =>
      LiberarPedidoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LiberarPedidoResponse.fromMap(Map<String, dynamic> json) =>
      LiberarPedidoResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        message: json["message"],
        pedidoLiberado: PedidoLiberado.fromMap(json["pedidoLiberado"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "message": message,
        "pedidoLiberado": pedidoLiberado!.toMap(),
      };
}

class PedidoLiberado {
  PedidoLiberado({
    required this.pedido,
    required this.codigo,
    required this.resultado,
    required this.mensajes,
  });

  String pedido;
  String codigo;
  bool resultado;
  List<dynamic> mensajes;

  factory PedidoLiberado.fromJson(String str) =>
      PedidoLiberado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoLiberado.fromMap(Map<String, dynamic> json) => PedidoLiberado(
        pedido: json["pedido"],
        codigo: json["codigo"],
        resultado: json["resultado"],
        mensajes: List<dynamic>.from(json["mensajes"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "pedido": pedido,
        "codigo": codigo,
        "resultado": resultado,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
      };
}
