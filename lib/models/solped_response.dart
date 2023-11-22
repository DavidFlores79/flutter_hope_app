// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 08/12/2022
 */

import 'dart:convert';

class SolpedResponse {
  int? code;
  String? status;
  String? message;
  List<Centros>? centrosUsuario;
  List<Posicion>? posiciones;

  SolpedResponse({
    this.code,
    this.status,
    this.message,
    this.centrosUsuario,
    this.posiciones,
  });

  factory SolpedResponse.fromJson(String str) =>
      SolpedResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SolpedResponse.fromMap(Map<String, dynamic> json) => SolpedResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        centrosUsuario: json["centros_usuario"] == null
            ? []
            : List<Centros>.from(
                json["centros_usuario"]!.map((x) => Centros.fromMap(x))),
        posiciones: json["posiciones"] == null
            ? []
            : List<Posicion>.from(
                json["posiciones"]!.map((x) => Posicion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "centros_usuario": centrosUsuario == null
            ? []
            : List<dynamic>.from(centrosUsuario!.map((x) => x.toMap())),
        "posiciones": posiciones == null
            ? []
            : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
      };
}

class Centros {
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

  Centros({
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

  factory Centros.fromJson(String str) => Centros.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Centros.fromMap(Map<String, dynamic> json) => Centros(
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

class Posicion {
  int? id;
  int? userId;
  int? centroId;
  int? estatusId;
  String? clasedocto;
  String? tipoMaterial;
  int? posicion;
  String? fechaSolicitud;
  dynamic fechaLiberacion;
  String? fechaEntrega;
  String? tipoFecha;
  String? usuarioCreacion;
  dynamic usuarioLiberacion;
  String? material;
  String? cuentaMayor;
  String? activoFijo;
  String? unidadMedida;
  String? gpoArticulo;
  String? textoBreve;
  String? textoRechazo;
  String? comentarios;
  String? cantidad;
  String? precio;
  String? gpoCompras;
  String? tipoImputacion;
  String? orgCompras;
  String? claveMoneda;
  dynamic documentoSap;
  dynamic documentoOc;
  dynamic fechaEliminado;
  String? createdAt;
  String? updatedAt;
  Centros? centros;
  Estatus? estatus;

  Posicion({
    this.id,
    this.userId,
    this.centroId,
    this.estatusId,
    this.clasedocto,
    this.tipoMaterial,
    this.posicion,
    this.fechaSolicitud,
    this.fechaLiberacion,
    this.fechaEntrega,
    this.tipoFecha,
    this.usuarioCreacion,
    this.usuarioLiberacion,
    this.material,
    this.cuentaMayor,
    this.activoFijo,
    this.unidadMedida,
    this.gpoArticulo,
    this.textoBreve,
    this.textoRechazo,
    this.comentarios,
    this.cantidad,
    this.precio,
    this.gpoCompras,
    this.tipoImputacion,
    this.orgCompras,
    this.claveMoneda,
    this.documentoSap,
    this.documentoOc,
    this.fechaEliminado,
    this.createdAt,
    this.updatedAt,
    this.centros,
    this.estatus,
  });

  factory Posicion.fromJson(String str) => Posicion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Posicion.fromMap(Map<String, dynamic> json) => Posicion(
        id: json["id"],
        userId: json["user_id"],
        centroId: json["centro_id"],
        estatusId: json["estatus_id"],
        clasedocto: json["clasedocto"],
        tipoMaterial: json["tipo_material"],
        posicion: json["posicion"],
        fechaSolicitud: json["fecha_solicitud"],
        fechaLiberacion: json["fecha_liberacion"],
        fechaEntrega: json["fecha_entrega"],
        tipoFecha: json["tipo_fecha"],
        usuarioCreacion: json["usuario_creacion"],
        usuarioLiberacion: json["usuario_liberacion"],
        material: json["material"],
        cuentaMayor: json["cuenta_mayor"],
        activoFijo: json["activo_fijo"],
        unidadMedida: json["unidad_medida"],
        gpoArticulo: json["gpo_articulo"],
        textoBreve: json["texto_breve"],
        textoRechazo: json["texto_rechazo"],
        comentarios: json["comentarios"],
        cantidad: json["cantidad"],
        precio: json["precio"],
        gpoCompras: json["gpo_compras"],
        tipoImputacion: json["tipo_imputacion"],
        orgCompras: json["org_compras"],
        claveMoneda: json["clave_moneda"],
        documentoSap: json["documento_sap"],
        documentoOc: json["documento_oc"],
        fechaEliminado: json["fecha_eliminado"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        centros:
            json["centros"] == null ? null : Centros.fromMap(json["centros"]),
        estatus:
            json["estatus"] == null ? null : Estatus.fromMap(json["estatus"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "centro_id": centroId,
        "estatus_id": estatusId,
        "clasedocto": clasedocto,
        "tipo_material": tipoMaterial,
        "posicion": posicion,
        "fecha_solicitud": fechaSolicitud,
        "fecha_liberacion": fechaLiberacion,
        "fecha_entrega": fechaEntrega,
        "tipo_fecha": tipoFecha,
        "usuario_creacion": usuarioCreacion,
        "usuario_liberacion": usuarioLiberacion,
        "material": material,
        "cuenta_mayor": cuentaMayor,
        "activo_fijo": activoFijo,
        "unidad_medida": unidadMedida,
        "gpo_articulo": gpoArticulo,
        "texto_breve": textoBreve,
        "texto_rechazo": textoRechazo,
        "comentarios": comentarios,
        "cantidad": cantidad,
        "precio": precio,
        "gpo_compras": gpoCompras,
        "tipo_imputacion": tipoImputacion,
        "org_compras": orgCompras,
        "clave_moneda": claveMoneda,
        "documento_sap": documentoSap,
        "documento_oc": documentoOc,
        "fecha_eliminado": fechaEliminado,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "centros": centros?.toMap(),
        "estatus": estatus?.toMap(),
      };
}

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
