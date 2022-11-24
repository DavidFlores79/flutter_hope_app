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
    required this.message,
  });

  int code;
  String status;
  Message message;

  factory LiberarPedidoResponse.fromJson(String str) =>
      LiberarPedidoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LiberarPedidoResponse.fromMap(Map<String, dynamic> json) =>
      LiberarPedidoResponse(
        code: json["code"],
        status: json["status"],
        message: Message.fromMap(json["message"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message.toMap(),
      };
}

class Message {
  Message({
    required this.pedido,
    required this.codigo,
    required this.resultado,
    required this.mensajes,
  });

  String pedido;
  String codigo;
  bool resultado;
  List<dynamic> mensajes;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
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

class ErrorLiberarPedidoResponse {
  ErrorLiberarPedidoResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.success,
  });

  int code;
  String status;
  String message;
  bool success;

  factory ErrorLiberarPedidoResponse.fromJson(String str) =>
      ErrorLiberarPedidoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorLiberarPedidoResponse.fromMap(Map<String, dynamic> json) =>
      ErrorLiberarPedidoResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "success": success,
      };
}
