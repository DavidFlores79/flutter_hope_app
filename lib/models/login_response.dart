/// Creado por: David Amilcar Flores Castillo
/// el 22/11/2022

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class LoginResponse {
  int? code;
  String? status;
  bool? success;
  User? user;
  String? jwt;
  Wss? wss;
  int? exp;

  LoginResponse({
    this.code,
    this.status,
    this.success,
    this.user,
    this.jwt,
    this.wss,
    this.exp,
  });

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        jwt: json["jwt"],
        wss: json["wss"] == null ? null : Wss.fromMap(json["wss"]),
        exp: json["exp"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "user": user?.toMap(),
        "jwt": jwt,
        "wss": wss?.toMap(),
        "exp": exp,
      };
}

class User {
  int? id;
  String? nombre;
  String? apellido;
  String? nickname;
  String? email;
  int? perfilId;
  String? tipoTrabajador;
  String? tipoUsuarioSap;
  dynamic idUsuarioSap;
  dynamic formatoTienda;
  dynamic ceco;
  dynamic telefono;
  dynamic deviceToken;
  dynamic fechaBaja;
  int? bloqueado;
  int? estatus;
  String? sessionId;
  String? lastActivity;
  String? createdAt;
  MiPerfil? miPerfil;
  List<Centro>? centros;

  User({
    this.id,
    this.nombre,
    this.apellido,
    this.nickname,
    this.email,
    this.perfilId,
    this.tipoTrabajador,
    this.tipoUsuarioSap,
    this.idUsuarioSap,
    this.formatoTienda,
    this.ceco,
    this.telefono,
    this.deviceToken,
    this.fechaBaja,
    this.bloqueado,
    this.estatus,
    this.sessionId,
    this.lastActivity,
    this.createdAt,
    this.miPerfil,
    this.centros,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        nickname: json["nickname"],
        email: json["email"],
        perfilId: json["perfil_id"],
        tipoTrabajador: json["tipo_trabajador"],
        tipoUsuarioSap: json["tipo_usuario_sap"],
        idUsuarioSap: json["id_usuario_sap"],
        formatoTienda: json["formato_tienda"],
        ceco: json["ceco"],
        telefono: json["telefono"],
        deviceToken: json["device_token"],
        fechaBaja: json["fecha_baja"],
        bloqueado: json["bloqueado"],
        estatus: json["estatus"],
        sessionId: json["session_id"],
        lastActivity: json["last_activity"],
        createdAt: json["created_at"],
        miPerfil: json["mi_perfil"] == null
            ? null
            : MiPerfil.fromMap(json["mi_perfil"]),
        centros: json["centros"] == null
            ? []
            : List<Centro>.from(json["centros"]!.map((x) => Centro.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "nickname": nickname,
        "email": email,
        "perfil_id": perfilId,
        "tipo_trabajador": tipoTrabajador,
        "tipo_usuario_sap": tipoUsuarioSap,
        "id_usuario_sap": idUsuarioSap,
        "formato_tienda": formatoTienda,
        "ceco": ceco,
        "telefono": telefono,
        "device_token": deviceToken,
        "fecha_baja": fechaBaja,
        "bloqueado": bloqueado,
        "estatus": estatus,
        "session_id": sessionId,
        "last_activity": lastActivity,
        "created_at": createdAt,
        "mi_perfil": miPerfil?.toMap(),
        "centros": centros == null
            ? []
            : List<dynamic>.from(centros!.map((x) => x.toMap())),
      };
}

class MiPerfil {
  int? id;
  String? nombre;
  dynamic descripcion;
  int? visible;
  int? estatus;

  MiPerfil({
    this.id,
    this.nombre,
    this.descripcion,
    this.visible,
    this.estatus,
  });

  factory MiPerfil.fromJson(String str) => MiPerfil.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MiPerfil.fromMap(Map<String, dynamic> json) => MiPerfil(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        visible: json["visible"],
        estatus: json["estatus"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "visible": visible,
        "estatus": estatus,
      };
}

class Wss {
  String? server;
  String? token;

  Wss({
    this.server,
    this.token,
  });

  factory Wss.fromJson(String str) => Wss.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Wss.fromMap(Map<String, dynamic> json) => Wss(
        server: json["server"],
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "server": server,
        "token": token,
      };
}
