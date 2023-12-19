// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 18/12/2023
 */

import 'dart:convert';
import 'package:hope_app/models/models.dart';

class ValidateBarcodeResponse {
    int? code;
    String? status;
    RespuestaApi? respuestaApi;
    IMdetalle? articulo;
    CabeceraInv? cabecera;

    ValidateBarcodeResponse({
        this.code,
        this.status,
        this.respuestaApi,
        this.articulo,
        this.cabecera,
    });

    factory ValidateBarcodeResponse.fromJson(String str) => ValidateBarcodeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ValidateBarcodeResponse.fromMap(Map<String, dynamic> json) => ValidateBarcodeResponse(
        code: json["code"],
        status: json["status"],
        respuestaApi: json["respuestaApi"] == null ? null : RespuestaApi.fromMap(json["respuestaApi"]),
        articulo: json["articulo"] == null ? null : IMdetalle.fromMap(json["articulo"]),
        cabecera: json["cabecera"] == null ? null : CabeceraInv.fromMap(json["cabecera"]),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "respuestaApi": respuestaApi?.toMap(),
        "articulo": articulo?.toMap(),
        "cabecera": cabecera?.toMap(),
    };
}

class CabeceraInv {
    String? centro;
    DateTime? fecha;
    String? idcabecera;

    CabeceraInv({
        this.centro,
        this.fecha,
        this.idcabecera,
    });

    factory CabeceraInv.fromJson(String str) => CabeceraInv.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CabeceraInv.fromMap(Map<String, dynamic> json) => CabeceraInv(
        centro: json["centro"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        idcabecera: json["idcabecera"],
    );

    Map<String, dynamic> toMap() => {
        "centro": centro,
        "fecha": "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
        "idcabecera": idcabecera,
    };
}

class RespuestaApi {
    bool? estatus;
    String? trace;
    String? timestamp;
    String? code;
    List<MaterialInv>? inventarios;

    RespuestaApi({
        this.estatus,
        this.trace,
        this.timestamp,
        this.code,
        this.inventarios,
    });

    factory RespuestaApi.fromJson(String str) => RespuestaApi.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RespuestaApi.fromMap(Map<String, dynamic> json) => RespuestaApi(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"],
        code: json["code"],
        inventarios: json["inventarios"] == null ? [] : List<MaterialInv>.from(json["inventarios"]!.map((x) => MaterialInv.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp": timestamp,
        "code": code,
        "inventarios": inventarios == null ? [] : List<dynamic>.from(inventarios!.map((x) => x.toMap())),
    };
}

class MaterialInv {
    dynamic umeSap;
    dynamic umeComercial;
    dynamic umeDescripcion;
    dynamic documento;
    dynamic almacenwm;
    dynamic almacen;
    dynamic numunidalmacen;
    dynamic posicion;
    dynamic cuanto;
    dynamic recuento;
    dynamic almacenTipo;
    dynamic ubicacion;
    String? material;
    dynamic centro;
    dynamic lote;
    dynamic tua;
    dynamic cantidad;
    String? unidad;
    dynamic unidadDes;
    dynamic fechaEm;
    dynamic isSerie;

    MaterialInv({
        this.umeSap,
        this.umeComercial,
        this.umeDescripcion,
        this.documento,
        this.almacenwm,
        this.almacen,
        this.numunidalmacen,
        this.posicion,
        this.cuanto,
        this.recuento,
        this.almacenTipo,
        this.ubicacion,
        this.material,
        this.centro,
        this.lote,
        this.tua,
        this.cantidad,
        this.unidad,
        this.unidadDes,
        this.fechaEm,
        this.isSerie,
    });

    factory MaterialInv.fromJson(String str) => MaterialInv.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MaterialInv.fromMap(Map<String, dynamic> json) => MaterialInv(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        documento: json["documento"],
        almacenwm: json["almacenwm"],
        almacen: json["almacen"],
        numunidalmacen: json["numunidalmacen"],
        posicion: json["posicion"],
        cuanto: json["cuanto"],
        recuento: json["recuento"],
        almacenTipo: json["almacenTipo"],
        ubicacion: json["ubicacion"],
        material: json["material"],
        centro: json["centro"],
        lote: json["lote"],
        tua: json["tua"],
        cantidad: json["cantidad"],
        unidad: json["unidad"],
        unidadDes: json["unidad_des"],
        fechaEm: json["fechaEm"],
        isSerie: json["isSerie"],
    );

    Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "documento": documento,
        "almacenwm": almacenwm,
        "almacen": almacen,
        "numunidalmacen": numunidalmacen,
        "posicion": posicion,
        "cuanto": cuanto,
        "recuento": recuento,
        "almacenTipo": almacenTipo,
        "ubicacion": ubicacion,
        "material": material,
        "centro": centro,
        "lote": lote,
        "tua": tua,
        "cantidad": cantidad,
        "unidad": unidad,
        "unidad_des": unidadDes,
        "fechaEm": fechaEm,
        "isSerie": isSerie,
    };
}
