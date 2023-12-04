import 'dart:convert';
import 'package:hope_app/models/centros.dart';

class ReciboEmbarqueResponse {
  int? code;
  String? status;
  List<Centros>? centrosUsuario;
  Embarque? dato;
  List<Embarque>? datos;

  ReciboEmbarqueResponse({
    this.code,
    this.status,
    this.centrosUsuario,
    this.dato,
    this.datos,
  });

  factory ReciboEmbarqueResponse.fromJson(String str) =>
      ReciboEmbarqueResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReciboEmbarqueResponse.fromMap(Map<String, dynamic> json) =>
      ReciboEmbarqueResponse(
        code: json["code"],
        status: json["status"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        datos: json["datos"] == null ? [] : List<Embarque>.from(json["datos"]!.map((x) => Embarque.fromMap(x))),
        dato: json["dato"] == null ? null : Embarque.fromMap(json["dato"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "datos": datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toMap())),
        "dato": dato?.toMap(),
      };
}

class Embarque {
    int? id;
    int? estatusId;
    String? usuarioVerificador;
    String? horaInicio;
    dynamic horaFinalizacion;
    List<Pallet>? pallets;
    String? createdAt;
    String? updatedAt;
    String? entrega;
    String? fechaEntrega;
    String? fechaPicking;
    String? centro;
    String? codigoTransporte;
    String? claseTransporte;
    double? pesoPlan;
    double? pesoNeto;
    dynamic estatus;

    Embarque({
        this.id,
        this.estatusId,
        this.usuarioVerificador,
        this.horaInicio,
        this.horaFinalizacion,
        this.pallets,
        this.createdAt,
        this.updatedAt,
        this.entrega,
        this.fechaEntrega,
        this.fechaPicking,
        this.centro,
        this.codigoTransporte,
        this.claseTransporte,
        this.pesoPlan,
        this.pesoNeto,
        this.estatus,
    });

    factory Embarque.fromJson(String str) => Embarque.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Embarque.fromMap(Map<String, dynamic> json) => Embarque(
        id: json["id"],
        estatusId: json["estatus_id"],
        usuarioVerificador: json["usuario_verificador"],
        horaInicio: json["hora_inicio"],
        horaFinalizacion: json["hora_finalizacion"],
        pallets: json["pallets"] == null ? [] : List<Pallet>.from(json["pallets"]!.map((x) => Pallet.fromMap(x))),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        entrega: json["entrega"],
        fechaEntrega: json["fecha_entrega"],
        fechaPicking: json["fecha_picking"],
        centro: json["centro"],
        codigoTransporte: json["codigo_transporte"],
        claseTransporte: json["clase_transporte"],
        pesoPlan: json["peso_plan"]?.toDouble(),
        pesoNeto: json["peso_neto"]?.toDouble(),
        estatus: json["estatus"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "estatus_id": estatusId,
        "usuario_verificador": usuarioVerificador,
        "hora_inicio": horaInicio,
        "hora_finalizacion": horaFinalizacion,
        "pallets": pallets == null ? [] : List<dynamic>.from(pallets!.map((x) => x.toMap())),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "entrega": entrega,
        "fecha_entrega": fechaEntrega,
        "fecha_picking": fechaPicking,
        "centro": centro,
        "codigo_transporte": codigoTransporte,
        "clase_transporte": claseTransporte,
        "peso_plan": pesoPlan,
        "peso_neto": pesoNeto,
        "estatus": estatus,
    };
}

class Pallet {
    String? entrega;
    String? unidadManipulacion;
    String? numeroContenedor;
    double? peso;
    double? volumen;
    String? estatus;

    Pallet({
        this.entrega,
        this.unidadManipulacion,
        this.numeroContenedor,
        this.peso,
        this.volumen,
        this.estatus,
    });

    factory Pallet.fromJson(String str) => Pallet.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pallet.fromMap(Map<String, dynamic> json) => Pallet(
        entrega: json["entrega"],
        unidadManipulacion: json["unidadManipulacion"],
        numeroContenedor: json["numeroContenedor"],
        peso: json["peso"]?.toDouble(),
        volumen: json["volumen"]?.toDouble(),
        estatus: json["estatus"],
    );

    Map<String, dynamic> toMap() => {
        "entrega": entrega,
        "unidadManipulacion": unidadManipulacion,
        "numeroContenedor": numeroContenedor,
        "peso": peso,
        "volumen": volumen,
        "estatus": estatus,
    };
}