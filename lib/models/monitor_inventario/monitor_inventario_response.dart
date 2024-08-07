// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 11/12/2023
 */

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class MonitorInventarioResponse {
  int? code;
  String? status;
  String? message;
  List<Inventario>? inventarios;
  String? messageUpdateCodbar;
  Inventario? inventario;
  String? messageUpdate;
  List<DetalleDetalle>? materialDetalles;

  MonitorInventarioResponse({
    this.code,
    this.status,
    this.message,
    this.inventarios,
    this.messageUpdateCodbar,
    this.inventario,
    this.messageUpdate,
    this.materialDetalles,
  });

  factory MonitorInventarioResponse.fromJson(String str) =>
      MonitorInventarioResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonitorInventarioResponse.fromMap(Map<String, dynamic> json) =>
      MonitorInventarioResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        inventarios: json["inventarios"] == null
            ? []
            : List<Inventario>.from(
                json["inventarios"]!.map((x) => Inventario.fromMap(x))),
        messageUpdateCodbar: json["messageUpdateCodbar"],
        inventario: json["inventario"] == null
            ? null
            : Inventario.fromMap(json["inventario"]),
        messageUpdate: json["messageUpdate"],
        materialDetalles: json["material_detalles"] == null
            ? []
            : List<DetalleDetalle>.from(json["material_detalles"]!
                .map((x) => DetalleDetalle.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "inventarios": inventarios == null
            ? []
            : List<dynamic>.from(inventarios!.map((x) => x.toMap())),
        "messageUpdateCodbar": messageUpdateCodbar,
        "inventario": inventario?.toMap(),
        "messageUpdate": messageUpdate,
        "material_detalles": materialDetalles == null
            ? []
            : List<dynamic>.from(materialDetalles!.map((x) => x.toMap())),
      };
}

class Inventario {
  int? id;
  int? centroId;
  String? documento;
  String? fecha;
  String? horaInicio;
  String? horaFin;
  int? estatus;
  String? createdAt;
  String? updatedAt;
  Centro? centro;
  List<InventarioDetalle>? detalles;

  Inventario({
    this.id,
    this.centroId,
    this.documento,
    this.fecha,
    this.horaInicio,
    this.horaFin,
    this.estatus,
    this.createdAt,
    this.updatedAt,
    this.centro,
    this.detalles,
  });

  factory Inventario.fromJson(String str) =>
      Inventario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Inventario.fromMap(Map<String, dynamic> json) => Inventario(
        id: json["id"],
        centroId: json["centro_id"],
        documento: json["documento"],
        fecha: json["fecha"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        estatus: json["estatus"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        centro: json["centro"] == null ? null : Centro.fromMap(json["centro"]),
        detalles: json["detalles"] == null
            ? []
            : List<InventarioDetalle>.from(
                json["detalles"]!.map((x) => InventarioDetalle.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "centro_id": centroId,
        "documento": documento,
        "fecha": fecha,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "estatus": estatus,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "centro": centro?.toMap(),
        "detalles": detalles == null
            ? []
            : List<dynamic>.from(detalles!.map((x) => x.toMap())),
      };
}

class InventarioDetalle {
  int? id;
  int? inventarioId;
  String? codbar;
  String? material;
  String? descripcion;
  String? cantidadTeorica;
  List<DetalleDetalle>? detalles;
  int? estatus;
  String? fechaContado;
  String? createdAt;
  String? updatedAt;
  String? umeComercial;
  String? cantidad;
  String? diferencia;

  InventarioDetalle({
    this.id,
    this.inventarioId,
    this.codbar,
    this.material,
    this.descripcion,
    this.cantidadTeorica,
    this.detalles,
    this.estatus,
    this.fechaContado,
    this.createdAt,
    this.updatedAt,
    this.umeComercial,
    this.cantidad,
    this.diferencia,
  });

  factory InventarioDetalle.fromJson(String str) =>
      InventarioDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InventarioDetalle.fromMap(Map<String, dynamic> json) =>
      InventarioDetalle(
        id: json["id"],
        inventarioId: json["inventario_id"],
        codbar: json["codbar"],
        material: json["material"],
        descripcion: json["descripcion"],
        cantidadTeorica: json["cantidadTeorica"],
        detalles: json["detalles"] == null
            ? []
            : List<DetalleDetalle>.from(
                json["detalles"]!.map((x) => DetalleDetalle.fromMap(x))),
        estatus: json["estatus"],
        fechaContado: json["fecha_contado"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        umeComercial: json["umeComercial"],
        cantidad: json["cantidad"],
        diferencia: json["diferencia"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "inventario_id": inventarioId,
        "codbar": codbar,
        "material": material,
        "descripcion": descripcion,
        "cantidadTeorica": cantidadTeorica,
        "detalles": detalles == null
            ? []
            : List<dynamic>.from(detalles!.map((x) => x.toMap())),
        "estatus": estatus,
        "fecha_contado": fechaContado,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "umeComercial": umeComercial,
        "cantidad": cantidad,
        "diferencia": diferencia,
      };
}

class DetalleDetalle {
  dynamic cantidad;
  String? mueble;
  String? responsable;

  DetalleDetalle({
    this.cantidad,
    this.mueble,
    this.responsable,
  });

  factory DetalleDetalle.fromJson(String str) =>
      DetalleDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetalleDetalle.fromMap(Map<String, dynamic> json) => DetalleDetalle(
        cantidad: json["cantidad"],
        mueble: json["mueble"],
        responsable: json["responsable"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "mueble": mueble,
        "responsable": responsable,
      };
}

class SaveInventarioRequest {
  Inventario? inventario;

  SaveInventarioRequest({
    this.inventario,
  });

  factory SaveInventarioRequest.fromJson(String str) =>
      SaveInventarioRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaveInventarioRequest.fromMap(Map<String, dynamic> json) =>
      SaveInventarioRequest(
        inventario: json["inventario"] == null
            ? null
            : Inventario.fromMap(json["inventario"]),
      );

  Map<String, dynamic> toMap() => {
        "inventario": inventario?.toMap(),
      };
}
