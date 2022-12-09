// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 08/12/2022
 */

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class LiberarMultiple {
  LiberarMultiple({
    required this.pedidos,
    required this.proveedor,
  });

  List<Pedido> pedidos;
  String proveedor;

  factory LiberarMultiple.fromJson(String str) =>
      LiberarMultiple.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LiberarMultiple.fromMap(Map<String, dynamic> json) => LiberarMultiple(
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromMap(x))),
        proveedor: json["proveedor"],
      );

  Map<String, dynamic> toMap() => {
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toMap())),
        "proveedor": proveedor,
      };
}

// class Pedido {
//     Pedido({
//         this.pedido,
//         this.numeroProveedor,
//         this.nombreProveedor,
//         this.fechaDocumento,
//         this.responsableSap,
//         this.importe,
//         this.grupoLiberacion,
//         this.codigoLiberacion,
//         this.posiciones,
//     });

//     String pedido;
//     String numeroProveedor;
//     String nombreProveedor;
//     DateTime fechaDocumento;
//     String responsableSap;
//     double importe;
//     String grupoLiberacion;
//     String codigoLiberacion;
//     List<dynamic> posiciones;

//     factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
//         pedido: json["pedido"],
//         numeroProveedor: json["numeroProveedor"],
//         nombreProveedor: json["nombreProveedor"],
//         fechaDocumento: DateTime.parse(json["fechaDocumento"]),
//         responsableSap: json["responsableSAP"],
//         importe: json["importe"].toDouble(),
//         grupoLiberacion: json["grupo_liberacion"],
//         codigoLiberacion: json["codigo_liberacion"],
//         posiciones: List<dynamic>.from(json["posiciones"].map((x) => x)),
//     );

//     Map<String, dynamic> toMap() => {
//         "pedido": pedido,
//         "numeroProveedor": numeroProveedor,
//         "nombreProveedor": nombreProveedor,
//         "fechaDocumento": "${fechaDocumento.year.toString().padLeft(4, '0')}-${fechaDocumento.month.toString().padLeft(2, '0')}-${fechaDocumento.day.toString().padLeft(2, '0')}",
//         "responsableSAP": responsableSap,
//         "importe": importe,
//         "grupo_liberacion": grupoLiberacion,
//         "codigo_liberacion": codigoLiberacion,
//         "posiciones": List<dynamic>.from(posiciones.map((x) => x)),
//     };
// }
