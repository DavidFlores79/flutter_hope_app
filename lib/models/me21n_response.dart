// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 23/11/2023
 */

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class ME21NResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;
  List<ClasesDocumento>? clasesDocumento;
  List<OrgCompras>? orgCompras;
  String? gpoCompras;

  ME21NResponse({
    this.code,
    this.status,
    this.centrosUsuario,
    this.clasesDocumento,
    this.orgCompras,
    this.gpoCompras,
  });

  factory ME21NResponse.fromJson(String str) =>
      ME21NResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ME21NResponse.fromMap(Map<String, dynamic> json) => ME21NResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        clasesDocumento: json["clases_documento"] == null
            ? []
            : List<ClasesDocumento>.from(json["clases_documento"]!
                .map((x) => ClasesDocumento.fromMap(x))),
        orgCompras: json["org_compras"] == null
            ? []
            : List<OrgCompras>.from(
                json["org_compras"]!.map((x) => OrgCompras.fromMap(x))),
        gpoCompras: json["gpo_compras"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "clases_documento": clasesDocumento == null
            ? []
            : List<dynamic>.from(clasesDocumento!.map((x) => x.toMap())),
        "org_compras": orgCompras == null
            ? []
            : List<dynamic>.from(orgCompras!.map((x) => x.toMap())),
        "gpo_compras": gpoCompras,
      };
}

class ClasesDocumento {
  int? id;
  String? name;
  String? code;
  bool? status;

  ClasesDocumento({
    this.id,
    this.name,
    this.code,
    this.status,
  });

  factory ClasesDocumento.fromJson(String str) =>
      ClasesDocumento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClasesDocumento.fromMap(Map<String, dynamic> json) => ClasesDocumento(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
      };
}

class OrgCompras {
  int? id;
  String? name;
  String? code;
  bool? status;

  OrgCompras({
    this.id,
    this.name,
    this.code,
    this.status,
  });

  factory OrgCompras.fromJson(String str) =>
      OrgCompras.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgCompras.fromMap(Map<String, dynamic> json) => OrgCompras(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
      };
}

/////////////////////////*************** RESPONSE DE CREACION DE PEDIDO ZSTT****************////////////////////////

class CreateOrderResponse {
  bool? estatus;
  String? trace;
  DateTime? timestamp;
  String? code;
  String? documentoPedido;
  // CabeceraPedido? cabeceraPedido;
  List<Posiciones>? posiciones;
  List<dynamic>? historial;
  List<dynamic>? retenciones;
  List<Mensaje>? mensajes;

  CreateOrderResponse({
    this.estatus,
    this.trace,
    this.timestamp,
    this.code,
    this.documentoPedido,
    // this.cabeceraPedido,
    // this.posiciones,
    this.historial,
    this.retenciones,
    this.mensajes,
  });

  factory CreateOrderResponse.fromJson(String str) =>
      CreateOrderResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateOrderResponse.fromMap(Map<String, dynamic> json) =>
      CreateOrderResponse(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        code: json["code"],
        documentoPedido: json["documento_pedido"],
        // cabeceraPedido: json["cabeceraPedido"] == null
        //     ? null
        //     : CabeceraPedido.fromMap(json["cabeceraPedido"]),
        // posiciones: json["posiciones"] == null
        //     ? []
        //     : List<Posiciones>.from(
        //         json["posiciones"]!.map((x) => Posiciones.fromMap(x))),
        historial: json["historial"] == null
            ? []
            : List<dynamic>.from(json["historial"]!.map((x) => x)),
        retenciones: json["retenciones"] == null
            ? []
            : List<dynamic>.from(json["retenciones"]!.map((x) => x)),
        mensajes: json["mensajes"] == null
            ? []
            : List<Mensaje>.from(
                json["mensajes"]!.map((x) => Mensaje.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp":
            "${timestamp!.year.toString().padLeft(4, '0')}-${timestamp!.month.toString().padLeft(2, '0')}-${timestamp!.day.toString().padLeft(2, '0')}",
        "code": code,
        "documento_pedido": documentoPedido,
        // "cabeceraPedido": cabeceraPedido?.toMap(),
        // "posiciones": posiciones == null
        //     ? []
        //     : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
        "historial": historial == null
            ? []
            : List<dynamic>.from(historial!.map((x) => x)),
        "retenciones": retenciones == null
            ? []
            : List<dynamic>.from(retenciones!.map((x) => x)),
        "mensajes": mensajes == null
            ? []
            : List<dynamic>.from(mensajes!.map((x) => x.toMap())),
      };
}
