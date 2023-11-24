import 'dart:convert';

import 'package:hope_app/models/models.dart';

/// Creado por: David Amilcar Flores Castillo
/// el 24/08/2023

class MigoEntrada101 {
  CabeceraPedido cabeceraPedido;
  String documentoPedido;
  String claseMovimiento;
  List<Posiciones> posiciones;
  DateTime fechaDoc;
  DateTime fechaCont;

  MigoEntrada101({
    required this.cabeceraPedido,
    required this.documentoPedido,
    required this.claseMovimiento,
    required this.posiciones,
    required this.fechaDoc,
    required this.fechaCont,
  });

  factory MigoEntrada101.fromJson(String str) =>
      MigoEntrada101.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MigoEntrada101.fromMap(Map<String, dynamic> json) => MigoEntrada101(
        cabeceraPedido: CabeceraPedido.fromMap(json["cabeceraPedido"]),
        documentoPedido: json["documento_pedido"],
        claseMovimiento: json["clase_movimiento"],
        posiciones: List<Posiciones>.from(
            json["posiciones"].map((x) => Posiciones.fromMap(x))),
        fechaDoc: DateTime.parse(json["fecha_doc"]),
        fechaCont: DateTime.parse(json["fecha_cont"]),
      );

  Map<String, dynamic> toMap() => {
        "cabeceraPedido": cabeceraPedido.toMap(),
        "documento_pedido": documentoPedido,
        "clase_movimiento": claseMovimiento,
        "posiciones": List<dynamic>.from(posiciones.map((x) => x.toMap())),
        "fecha_doc":
            "${fechaDoc.year.toString().padLeft(4, '0')}-${fechaDoc.month.toString().padLeft(2, '0')}-${fechaDoc.day.toString().padLeft(2, '0')}",
        "fecha_cont":
            "${fechaCont.year.toString().padLeft(4, '0')}-${fechaCont.month.toString().padLeft(2, '0')}-${fechaCont.day.toString().padLeft(2, '0')}",
      };
}
