import 'dart:convert';

import 'package:hope_app/models/models.dart';

class ValidateMaterialWithCenterResponse {
    int? code;
    String? status;
    String? message;
    RespuestaApiMaterial? respuestaApi;

    ValidateMaterialWithCenterResponse({
        this.code,
        this.status,
        this.message,
        this.respuestaApi,
    });

    factory ValidateMaterialWithCenterResponse.fromJson(String str) => ValidateMaterialWithCenterResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ValidateMaterialWithCenterResponse.fromMap(Map<String, dynamic> json) => ValidateMaterialWithCenterResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        respuestaApi: json["respuestaApi"] == null ? null : RespuestaApiMaterial.fromMap(json["respuestaApi"]),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "respuestaApi": respuestaApi?.toMap(),
    };
}

class RespuestaApiMaterial {
    bool? estatus;
    String? trace;
    DateTime? timestamp;
    String? code;
    List<DetallesInventario>? inventarios;

    RespuestaApiMaterial({
        this.estatus,
        this.trace,
        this.timestamp,
        this.code,
        this.inventarios,
    });

    factory RespuestaApiMaterial.fromJson(String str) => RespuestaApiMaterial.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RespuestaApiMaterial.fromMap(Map<String, dynamic> json) => RespuestaApiMaterial(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        code: json["code"],
        inventarios: json["inventarios"] == null ? [] : List<DetallesInventario>.from(json["inventarios"]!.map((x) => DetallesInventario.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp": "${timestamp!.year.toString().padLeft(4, '0')}-${timestamp!.month.toString().padLeft(2, '0')}-${timestamp!.day.toString().padLeft(2, '0')}",
        "code": code,
        "inventarios": inventarios == null ? [] : List<dynamic>.from(inventarios!.map((x) => x.toMap())),
    };
}

class DetallesInventario {
    bool? aplicado;
    List<IMdetalle>? inventarioimdet;

    DetallesInventario({
        this.aplicado,
        this.inventarioimdet,
    });

    factory DetallesInventario.fromJson(String str) => DetallesInventario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DetallesInventario.fromMap(Map<String, dynamic> json) => DetallesInventario(
        aplicado: json["aplicado"],
        inventarioimdet: json["inventarioimdet"] == null ? [] : List<IMdetalle>.from(json["inventarioimdet"]!.map((x) => IMdetalle.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "aplicado": aplicado,
        "inventarioimdet": inventarioimdet == null ? [] : List<dynamic>.from(inventarioimdet!.map((x) => x.toMap())),
    };
}
