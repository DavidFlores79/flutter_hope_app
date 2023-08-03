// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 02/08/2023
 */

import 'dart:convert';

class ModuleResponse {
  int code;
  String status;
  List<CategoriasModulo> categoriasModulos;

  ModuleResponse({
    required this.code,
    required this.status,
    required this.categoriasModulos,
  });

  factory ModuleResponse.fromJson(String str) =>
      ModuleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModuleResponse.fromMap(Map<String, dynamic> json) => ModuleResponse(
        code: json["code"],
        status: json["status"],
        categoriasModulos: List<CategoriasModulo>.from(
            json["categoriasModulos"].map((x) => CategoriasModulo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "categoriasModulos":
            List<dynamic>.from(categoriasModulos.map((x) => x.toMap())),
      };
}

class CategoriasModulo {
  int id;
  String descripcionCorta;
  String descripcionLarga;
  List<Modulo> modulos;

  CategoriasModulo({
    required this.id,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.modulos,
  });

  factory CategoriasModulo.fromJson(String str) =>
      CategoriasModulo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriasModulo.fromMap(Map<String, dynamic> json) =>
      CategoriasModulo(
        id: json["id"],
        descripcionCorta: json["descripcion_corta"],
        descripcionLarga: json["descripcion_larga"],
        modulos:
            List<Modulo>.from(json["modulos"].map((x) => Modulo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion_corta": descripcionCorta,
        "descripcion_larga": descripcionLarga,
        "modulos": List<dynamic>.from(modulos.map((x) => x.toMap())),
      };
}

class Modulo {
  int id;
  String nombre;
  String ruta;
  String icono;

  Modulo({
    required this.id,
    required this.nombre,
    required this.ruta,
    required this.icono,
  });

  factory Modulo.fromJson(String str) => Modulo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Modulo.fromMap(Map<String, dynamic> json) => Modulo(
        id: json["id"],
        nombre: json["nombre"],
        ruta: json["ruta"],
        icono: json["icono"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "ruta": ruta,
        "icono": icono,
      };
}
