import 'dart:convert';
import 'package:hope_app/models/centros.dart';

class ConsultaStockResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;
  Stock? stock;

  ConsultaStockResponse({
    this.code,
    this.status,
    this.centrosUsuario,
    this.stock,
  });

  factory ConsultaStockResponse.fromJson(String str) =>
      ConsultaStockResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsultaStockResponse.fromMap(Map<String, dynamic> json) =>
      ConsultaStockResponse(
        code: json["code"],
        status: json["status"],
        stock: json["stock"] == null ? null : Stock.fromMap(json["stock"]),
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "stock": stock?.toMap(),
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
      };
}

class Stock {
    String? centro;
    List<DetalleStock>? detalleStock;

    Stock({
        this.centro,
        this.detalleStock,
    });

    factory Stock.fromJson(String str) => Stock.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Stock.fromMap(Map<String, dynamic> json) => Stock(
        centro: json["centro"],
        detalleStock: json["detalle_stock"] == null ? [] : List<DetalleStock>.from(json["detalle_stock"]!.map((x) => DetalleStock.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "centro": centro,
        "detalle_stock": detalleStock == null ? [] : List<dynamic>.from(detalleStock!.map((x) => x.toMap())),
    };
}

class DetalleStock {
    String? centro;
    String? grupoArticulo;
    String? numeroMaterial;
    String? descripcionMaterial;
    int? stockLibre;
    int? stockTransito;

    DetalleStock({
        this.centro,
        this.grupoArticulo,
        this.numeroMaterial,
        this.descripcionMaterial,
        this.stockLibre,
        this.stockTransito,
    });

    factory DetalleStock.fromJson(String str) => DetalleStock.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DetalleStock.fromMap(Map<String, dynamic> json) => DetalleStock(
        centro: json["centro"],
        grupoArticulo: json["grupo_articulo"],
        numeroMaterial: json["numero_material"],
        descripcionMaterial: json["descripcion_material"],
        stockLibre: json["stock_libre"],
        stockTransito: json["stock_transito"],
    );

    Map<String, dynamic> toMap() => {
        "centro": centro,
        "grupo_articulo": grupoArticulo,
        "numero_material": numeroMaterial,
        "descripcion_material": descripcionMaterial,
        "stock_libre": stockLibre,
        "stock_transito": stockTransito,
    };
}