/// Creado por: David Amilcar Flores Castillo
/// el 22/11/2022

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.code,
    required this.status,
    required this.success,
    required this.user,
    required this.jwt,
    required this.exp,
  });

  int code;
  String status;
  bool success;
  User user;
  String jwt;
  int exp;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        user: User.fromMap(json["user"]),
        jwt: json["jwt"],
        exp: json["exp"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "user": user.toMap(),
        "jwt": jwt,
        "exp": exp,
      };
}

class User {
  User({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nickname,
    required this.email,
    required this.perfilId,
    required this.tipoTrabajador,
    this.ceco,
    this.telefono,
    this.fechaBaja,
    required this.bloqueado,
    required this.estatus,
    required this.createdAt,
    this.deviceToken,
  });

  int id;
  String nombre;
  String apellido;
  String nickname;
  String email;
  int perfilId;
  String tipoTrabajador;
  String? ceco;
  String? telefono;
  String? fechaBaja;
  int bloqueado;
  int estatus;
  String createdAt;
  String? deviceToken;

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
        ceco: json["ceco"],
        telefono: json["telefono"],
        fechaBaja: json["fecha_baja"],
        bloqueado: json["bloqueado"],
        estatus: json["estatus"],
        createdAt: json["created_at"],
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "nickname": nickname,
        "email": email,
        "perfil_id": perfilId,
        "tipo_trabajador": tipoTrabajador,
        "ceco": ceco,
        "telefono": telefono,
        "fecha_baja": fechaBaja,
        "bloqueado": bloqueado,
        "estatus": estatus,
        "created_at": createdAt,
        "device_token": deviceToken,
      };
}
