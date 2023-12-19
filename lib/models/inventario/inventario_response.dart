// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 15/12/2023
 */

import 'dart:convert';
import 'package:hope_app/models/models.dart';

class InventarioResponse {
    int? code;
    String? status;
    List<Centros>? centrosUsuario;
    String? message;
    RespuestaSap? respuestaSap;

    InventarioResponse({
        this.code,
        this.status,
        this.centrosUsuario,
        this.message,
        this.respuestaSap,
    });

    factory InventarioResponse.fromJson(String str) => InventarioResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InventarioResponse.fromMap(Map<String, dynamic> json) => InventarioResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null ? [] : List<Centros>.from(json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        message: json["message"],
        respuestaSap: json["respuestaSap"] == null ? null : RespuestaSap.fromMap(json["respuestaSap"]),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null ? [] : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "message": message,
        "respuestaSap": respuestaSap?.toMap(),
    };
}

class RespuestaSap {
    bool? estatus;
    String? trace;
    DateTime? timestamp;
    String? code;
    List<InventarioSAP>? inventarios;

    RespuestaSap({
        this.estatus,
        this.trace,
        this.timestamp,
        this.code,
        this.inventarios,
    });

    factory RespuestaSap.fromJson(String str) => RespuestaSap.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RespuestaSap.fromMap(Map<String, dynamic> json) => RespuestaSap(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        code: json["code"],
        inventarios: json["inventarios"] == null ? [] : List<InventarioSAP>.from(json["inventarios"]!.map((x) => InventarioSAP.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp": "${timestamp!.year.toString().padLeft(4, '0')}-${timestamp!.month.toString().padLeft(2, '0')}-${timestamp!.day.toString().padLeft(2, '0')}",
        "code": code,
        "inventarios": inventarios == null ? [] : List<dynamic>.from(inventarios!.map((x) => x.toMap())),
    };
}

class InventarioSAP {
    int? idcabecera;
    String? fecha;
    String? centro;
    bool? aplicado;
    List<InventarioIMDetSAP>? inventarioimdet;

    InventarioSAP({
        this.idcabecera,
        this.fecha,
        this.centro,
        this.aplicado,
        this.inventarioimdet,
    });

    factory InventarioSAP.fromJson(String str) => InventarioSAP.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InventarioSAP.fromMap(Map<String, dynamic> json) => InventarioSAP(
        idcabecera: json["idcabecera"],
        fecha: json["fecha"],
        centro: json["centro"],
        aplicado: json["aplicado"],
        inventarioimdet: json["inventarioimdet"] == null ? [] : List<InventarioIMDetSAP>.from(json["inventarioimdet"]!.map((x) => InventarioIMDetSAP.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "idcabecera": idcabecera,
        "fecha": fecha,
        "centro": centro,
        "aplicado": aplicado,
        "inventarioimdet": inventarioimdet == null ? [] : List<dynamic>.from(inventarioimdet!.map((x) => x.toMap())),
    };
}

class InventarioIMDetSAP {
    String? umeSap;
    String? umeComercial;
    String? umeDescripcion;
    int? iddetalle;
    String? codbar;
    String? mueble;
    String? usuario;
    String? material;
    String? descripcion;
    int? cantidad;
    int? cantidadTeorica;
    List<dynamic>? inventarioimser;

    InventarioIMDetSAP({
        this.umeSap,
        this.umeComercial,
        this.umeDescripcion,
        this.iddetalle,
        this.codbar,
        this.mueble,
        this.usuario,
        this.material,
        this.descripcion,
        this.cantidad,
        this.cantidadTeorica,
        this.inventarioimser,
    });

    factory InventarioIMDetSAP.fromJson(String str) => InventarioIMDetSAP.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InventarioIMDetSAP.fromMap(Map<String, dynamic> json) => InventarioIMDetSAP(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        iddetalle: json["iddetalle"],
        codbar: json["codbar"],
        mueble: json["mueble"],
        usuario: json["usuario"],
        material: json["material"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        cantidadTeorica: json["cantidadTeorica"],
        inventarioimser: json["inventarioimser"] == null ? [] : List<dynamic>.from(json["inventarioimser"]!.map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "iddetalle": iddetalle,
        "codbar": codbar,
        "mueble": mueble,
        "usuario": usuario,
        "material": material,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "cantidadTeorica": cantidadTeorica,
        "inventarioimser": inventarioimser == null ? [] : List<dynamic>.from(inventarioimser!.map((x) => x)),
    };
}

class IMdetalle {
    String? codbar;
    String? material;
    String? descripcion;
    String? umeComercial;
    double? cantidad;

    IMdetalle({
        this.codbar,
        this.material,
        this.descripcion,
        this.umeComercial,
        this.cantidad,
    });

    factory IMdetalle.fromJson(String str) => IMdetalle.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IMdetalle.fromMap(Map<String, dynamic> json) => IMdetalle(
        codbar: json["codbar"],
        material: json["material"],
        descripcion: json["descripcion"],
        umeComercial: json["umeComercial"],
        cantidad: (json["cantidad"] is int || json["cantidad"] is double) ? json["cantidad"]?.toDouble() : double.parse(json["cantidad"]),
    );

    Map<String, dynamic> toMap() => {
        "codbar": codbar,
        "material": material,
        "descripcion": descripcion,
        "umeComercial": umeComercial,
        "cantidad": cantidad,
    };
}