// To parse this JSON data, do
//
//     final liberarMultipleResponse = liberarMultipleResponseFromMap(jsonString);

import 'dart:convert';

class LiberarMultipleResponse {
  LiberarMultipleResponse({
    required this.code,
    required this.status,
    required this.success,
    required this.orders,
  });

  int code;
  String status;
  bool success;
  List<Order> orders;

  factory LiberarMultipleResponse.fromJson(String str) =>
      LiberarMultipleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LiberarMultipleResponse.fromMap(Map<String, dynamic> json) =>
      LiberarMultipleResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "orders": List<dynamic>.from(orders.map((x) => x.toMap())),
      };
}

class Order {
  Order({
    required this.order,
    required this.code,
    required this.estadLiberacion,
    required this.indicadorLiberacion,
    required this.resultado,
    required this.mensajes,
  });

  String order;
  String code;
  String estadLiberacion;
  String indicadorLiberacion;
  bool resultado;
  List<dynamic> mensajes;

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        order: json["order"],
        code: json["code"],
        estadLiberacion: json["estadLiberacion"],
        indicadorLiberacion: json["indicadorLiberacion"],
        resultado: json["resultado"],
        mensajes: List<dynamic>.from(json["mensajes"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "order": order,
        "code": code,
        "estadLiberacion": estadLiberacion,
        "indicadorLiberacion": indicadorLiberacion,
        "resultado": resultado,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
      };
}
