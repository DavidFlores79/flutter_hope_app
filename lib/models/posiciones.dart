import 'dart:convert';

import 'package:hope_app/models/models.dart';

class Posicion {
  int? id;
  int? userId;
  int? centroId;
  String? centro;
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
  dynamic sociedad;
  String? createdAt;
  String? updatedAt;
  Centros? centros;
  Estatus? estatus;

  Posicion({
    this.id,
    this.userId,
    this.centroId,
    this.centro,
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
    this.sociedad,
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
        centro: json["centro"],
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
        sociedad: json["sociedad"],
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
        "centro": centro,
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
        "sociedad": sociedad,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "centros": centros?.toMap(),
        "estatus": estatus?.toMap(),
      };
}

class Posiciones {
  String umeSap;
  String umeComercial;
  String umeDescripcion;
  int posicion;
  String deleteIndicador;
  String numeroPedido;
  String numeroMaterial;
  String descripcionMaterial;
  dynamic documentoMaterial;
  dynamic documentoAnio;
  dynamic documentoPos;
  String cantidad;
  String cantidadRecibida;
  dynamic importe;
  dynamic importeRecibido;
  String unidadMedida;
  String centroReceptor;
  String almacen;
  bool indicadorEntregaFinal;
  String indicadorImpuesto;
  bool esSerealizado;
  bool esDevolucion;
  String solicitante;
  List<dynamic> series;
  String cantidadFaltante;

  Posiciones({
    required this.umeSap,
    required this.umeComercial,
    required this.umeDescripcion,
    required this.posicion,
    required this.deleteIndicador,
    required this.numeroPedido,
    required this.numeroMaterial,
    required this.descripcionMaterial,
    required this.documentoMaterial,
    required this.documentoAnio,
    required this.documentoPos,
    required this.cantidad,
    required this.cantidadRecibida,
    required this.importe,
    required this.importeRecibido,
    required this.unidadMedida,
    required this.centroReceptor,
    required this.almacen,
    required this.indicadorEntregaFinal,
    required this.indicadorImpuesto,
    required this.esSerealizado,
    required this.esDevolucion,
    required this.solicitante,
    required this.series,
    required this.cantidadFaltante,
  });

  factory Posiciones.fromJson(String str) =>
      Posiciones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Posiciones.fromMap(Map<String, dynamic> json) => Posiciones(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        posicion: json["posicion"],
        deleteIndicador: json["delete_indicador"],
        numeroPedido: json["numero_pedido"],
        numeroMaterial: json["numero_material"],
        descripcionMaterial: json["descripcion_material"],
        documentoMaterial: json["documento_material"],
        documentoAnio: json["documento_anio"],
        documentoPos: json["documento_pos"],
        cantidad: json["cantidad"],
        cantidadRecibida: json["cantidad_recibida"],
        importe: json["importe"],
        importeRecibido: json["importe_recibido"],
        unidadMedida: json["unidad_medida"],
        centroReceptor: json["centro_receptor"],
        almacen: json["almacen"],
        indicadorEntregaFinal: json["indicador_entrega_final"],
        indicadorImpuesto: json["indicador_impuesto"],
        esSerealizado: json["es_serealizado"],
        esDevolucion: json["es_devolucion"],
        solicitante: json["solicitante"],
        series: List<dynamic>.from(json["series"].map((x) => x)),
        cantidadFaltante: json["cantidad_faltante"],
      );

  Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "posicion": posicion,
        "delete_indicador": deleteIndicador,
        "numero_pedido": numeroPedido,
        "numero_material": numeroMaterial,
        "descripcion_material": descripcionMaterial,
        "documento_material": documentoMaterial,
        "documento_anio": documentoAnio,
        "documento_pos": documentoPos,
        "cantidad": cantidad,
        "cantidad_recibida": cantidadRecibida,
        "importe": importe,
        "importe_recibido": importeRecibido,
        "unidad_medida": unidadMedida,
        "centro_receptor": centroReceptor,
        "almacen": almacen,
        "indicador_entrega_final": indicadorEntregaFinal,
        "indicador_impuesto": indicadorImpuesto,
        "es_serealizado": esSerealizado,
        "es_devolucion": esDevolucion,
        "solicitante": solicitante,
        "series": List<dynamic>.from(series.map((x) => x)),
        "cantidad_faltante": cantidadFaltante,
      };
}
