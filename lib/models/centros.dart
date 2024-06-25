import 'dart:convert';

class Centro {
  int? id;
  String? idcentro;
  String? cebe;
  String? ceco;
  String? orgCompras;
  String? sociedad;
  String? sociedadCo;
  String? nombre;
  String? claveMoneda;
  String? almacenIm;
  String? almacenWm;
  int? estatus;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot? pivot;

  Centro({
    this.id,
    this.idcentro,
    this.cebe,
    this.ceco,
    this.orgCompras,
    this.sociedad,
    this.sociedadCo,
    this.nombre,
    this.claveMoneda,
    this.almacenIm,
    this.almacenWm,
    this.estatus,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Centro.fromJson(String str) => Centro.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Centro.fromMap(Map<String, dynamic> json) => Centro(
        id: json["id"],
        idcentro: json["idcentro"],
        cebe: json["cebe"],
        ceco: json["ceco"],
        orgCompras: json["org_compras"],
        sociedad: json["sociedad"],
        sociedadCo: json["sociedad_co"],
        nombre: json["nombre"],
        claveMoneda: json["clave_moneda"],
        almacenIm: json["almacen_im"],
        almacenWm: json["almacen_wm"],
        estatus: json["estatus"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "idcentro": idcentro,
        "cebe": cebe,
        "ceco": ceco,
        "org_compras": orgCompras,
        "sociedad": sociedad,
        "sociedad_co": sociedadCo,
        "nombre": nombre,
        "clave_moneda": claveMoneda,
        "almacen_im": almacenIm,
        "almacen_wm": almacenWm,
        "estatus": estatus,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot?.toMap(),
      };
}

class Pivot {
  int? userId;
  int? centroId;

  Pivot({
    this.userId,
    this.centroId,
  });

  factory Pivot.fromJson(String str) => Pivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        centroId: json["centro_id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "centro_id": centroId,
      };
}
