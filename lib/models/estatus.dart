import 'dart:convert';

class Estatus {
  int? id;
  String? descripcion;
  int? estatus;
  String? createdAt;
  String? updatedAt;

  Estatus({
    this.id,
    this.descripcion,
    this.estatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Estatus.fromJson(String str) => Estatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Estatus.fromMap(Map<String, dynamic> json) => Estatus(
        id: json["id"],
        descripcion: json["descripcion"],
        estatus: json["estatus"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion": descripcion,
        "estatus": estatus,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
