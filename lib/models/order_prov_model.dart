// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 22/11/2022
 */

import 'dart:convert' show json;

import 'package:productos_app/models/order_response.dart';

class PedidosProvModel {
  PedidosProvModel({
    required this.code,
    required this.status,
    required this.pedidosProv,
  });

  int code;
  String status;
  List<PedidosProv> pedidosProv;

  factory PedidosProvModel.fromJson(String str) =>
      PedidosProvModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidosProvModel.fromMap(Map<String, dynamic> json) =>
      PedidosProvModel(
        code: json["code"],
        status: json["status"],
        pedidosProv: List<PedidosProv>.from(
            json["pedidosProv"].map((x) => PedidosProv.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "pedidosProv": List<dynamic>.from(pedidosProv.map((x) => x.toMap())),
      };
}

class PedidosProv {
  PedidosProv({
    required this.proveedor,
    required this.pedidos,
  });

  String proveedor;
  List<Pedido> pedidos;

  factory PedidosProv.fromJson(String str) =>
      PedidosProv.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidosProv.fromMap(Map<String, dynamic> json) => PedidosProv(
        proveedor: json["proveedor"],
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "proveedor": proveedor,
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toMap())),
      };
}
