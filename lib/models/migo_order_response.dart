import 'dart:convert';

import 'package:hope_app/models/models.dart';

/// Creado por: David Amilcar Flores Castillo
/// el 23/08/2023

class MigoOrderResponse {
  int code;
  String message;
  String status;
  PedidoMigo? pedidoMigo;
  String userlog;

  MigoOrderResponse({
    required this.code,
    required this.message,
    required this.status,
    this.pedidoMigo,
    required this.userlog,
  });

  factory MigoOrderResponse.fromJson(String str) =>
      MigoOrderResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MigoOrderResponse.fromMap(Map<String, dynamic> json) =>
      MigoOrderResponse(
        code: json["code"],
        message: json["message"],
        status: json["status"],
        pedidoMigo: PedidoMigo.fromMap(json["pedido_migo"]),
        userlog: json["userlog"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "status": status,
        "pedido_migo": pedidoMigo!.toMap(),
        "userlog": userlog,
      };
}

class PedidoMigo {
  CabeceraPedido cabeceraPedido;
  String documentoPedido;
  bool estatus;
  List<dynamic> mensajes;
  String trace;
  List<Posiciones> posiciones;

  PedidoMigo({
    required this.cabeceraPedido,
    required this.documentoPedido,
    required this.estatus,
    required this.mensajes,
    required this.trace,
    required this.posiciones,
  });

  factory PedidoMigo.fromJson(String str) =>
      PedidoMigo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoMigo.fromMap(Map<String, dynamic> json) => PedidoMigo(
        cabeceraPedido: CabeceraPedido.fromMap(json["cabeceraPedido"]),
        documentoPedido: json["documento_pedido"],
        estatus: json["estatus"],
        mensajes: List<dynamic>.from(json["mensajes"].map((x) => x)),
        trace: json["trace"],
        posiciones: List<Posiciones>.from(
            json["posiciones"].map((x) => Posiciones.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cabeceraPedido": cabeceraPedido.toMap(),
        "documento_pedido": documentoPedido,
        "estatus": estatus,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
        "trace": trace,
        "posiciones": List<dynamic>.from(posiciones.map((x) => x.toMap())),
      };
}

class CabeceraPedido {
  String sociedad;
  String indicadorBorrado;
  DateTime fechaCreacionRegistro;
  String responsableCreacion;
  String cuentaProveedor;
  dynamic proveedorMercancias;
  DateTime fechaDocumentoCompras;
  String referencia;
  String centroSuministrador;
  String numeroPedido;
  dynamic tipoPedido;
  dynamic orgCompras;
  dynamic gpoCompras;
  String moneda;
  String clavePago;
  bool seVerifica;
  dynamic nuestraReferencia;
  String claseDocumento;

  CabeceraPedido({
    required this.sociedad,
    required this.indicadorBorrado,
    required this.fechaCreacionRegistro,
    required this.responsableCreacion,
    required this.cuentaProveedor,
    required this.proveedorMercancias,
    required this.fechaDocumentoCompras,
    required this.referencia,
    required this.centroSuministrador,
    required this.numeroPedido,
    required this.tipoPedido,
    required this.orgCompras,
    required this.gpoCompras,
    required this.moneda,
    required this.clavePago,
    required this.seVerifica,
    required this.nuestraReferencia,
    required this.claseDocumento,
  });

  factory CabeceraPedido.fromJson(String str) =>
      CabeceraPedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CabeceraPedido.fromMap(Map<String, dynamic> json) => CabeceraPedido(
        sociedad: json["sociedad"],
        indicadorBorrado: json["indicador_borrado"],
        fechaCreacionRegistro: DateTime.parse(json["fecha_creacion_registro"]),
        responsableCreacion: json["responsable_creacion"],
        cuentaProveedor: json["cuenta_proveedor"],
        proveedorMercancias: json["proveedor_mercancias"],
        fechaDocumentoCompras: DateTime.parse(json["fecha_documento_compras"]),
        referencia: json["referencia"],
        centroSuministrador: json["centro_suministrador"],
        numeroPedido: json["numero_pedido"],
        tipoPedido: json["tipo_pedido"],
        orgCompras: json["org_compras"],
        gpoCompras: json["gpo_compras"],
        moneda: json["moneda"],
        clavePago: json["clave_pago"],
        seVerifica: json["se_verifica"],
        nuestraReferencia: json["nuestra_referencia"],
        claseDocumento: json["clase_documento"],
      );

  Map<String, dynamic> toMap() => {
        "sociedad": sociedad,
        "indicador_borrado": indicadorBorrado,
        "fecha_creacion_registro":
            "${fechaCreacionRegistro.year.toString().padLeft(4, '0')}-${fechaCreacionRegistro.month.toString().padLeft(2, '0')}-${fechaCreacionRegistro.day.toString().padLeft(2, '0')}",
        "responsable_creacion": responsableCreacion,
        "cuenta_proveedor": cuentaProveedor,
        "proveedor_mercancias": proveedorMercancias,
        "fecha_documento_compras":
            "${fechaDocumentoCompras.year.toString().padLeft(4, '0')}-${fechaDocumentoCompras.month.toString().padLeft(2, '0')}-${fechaDocumentoCompras.day.toString().padLeft(2, '0')}",
        "referencia": referencia,
        "centro_suministrador": centroSuministrador,
        "numero_pedido": numeroPedido,
        "tipo_pedido": tipoPedido,
        "org_compras": orgCompras,
        "gpo_compras": gpoCompras,
        "moneda": moneda,
        "clave_pago": clavePago,
        "se_verifica": seVerifica,
        "nuestra_referencia": nuestraReferencia,
        "clase_documento": claseDocumento,
      };
}

// class Posiciones {
//   String umeSap;
//   String umeComercial;
//   String umeDescripcion;
//   int posicion;
//   String deleteIndicador;
//   String numeroPedido;
//   String numeroMaterial;
//   String descripcionMaterial;
//   dynamic documentoMaterial;
//   dynamic documentoAnio;
//   dynamic documentoPos;
//   String cantidad;
//   String cantidadRecibida;
//   dynamic importe;
//   dynamic importeRecibido;
//   String unidadMedida;
//   String centroReceptor;
//   String almacen;
//   bool indicadorEntregaFinal;
//   String indicadorImpuesto;
//   bool esSerealizado;
//   bool esDevolucion;
//   String solicitante;
//   List<dynamic> series;
//   String cantidadFaltante;

//   Posiciones({
//     required this.umeSap,
//     required this.umeComercial,
//     required this.umeDescripcion,
//     required this.posicion,
//     required this.deleteIndicador,
//     required this.numeroPedido,
//     required this.numeroMaterial,
//     required this.descripcionMaterial,
//     required this.documentoMaterial,
//     required this.documentoAnio,
//     required this.documentoPos,
//     required this.cantidad,
//     required this.cantidadRecibida,
//     required this.importe,
//     required this.importeRecibido,
//     required this.unidadMedida,
//     required this.centroReceptor,
//     required this.almacen,
//     required this.indicadorEntregaFinal,
//     required this.indicadorImpuesto,
//     required this.esSerealizado,
//     required this.esDevolucion,
//     required this.solicitante,
//     required this.series,
//     required this.cantidadFaltante,
//   });

//   factory Posiciones.fromJson(String str) =>
//       Posiciones.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Posiciones.fromMap(Map<String, dynamic> json) => Posiciones(
//         umeSap: json["umeSAP"],
//         umeComercial: json["umeComercial"],
//         umeDescripcion: json["umeDescripcion"],
//         posicion: json["posicion"],
//         deleteIndicador: json["delete_indicador"],
//         numeroPedido: json["numero_pedido"],
//         numeroMaterial: json["numero_material"],
//         descripcionMaterial: json["descripcion_material"],
//         documentoMaterial: json["documento_material"],
//         documentoAnio: json["documento_anio"],
//         documentoPos: json["documento_pos"],
//         cantidad: json["cantidad"],
//         cantidadRecibida: json["cantidad_recibida"],
//         importe: json["importe"],
//         importeRecibido: json["importe_recibido"],
//         unidadMedida: json["unidad_medida"],
//         centroReceptor: json["centro_receptor"],
//         almacen: json["almacen"],
//         indicadorEntregaFinal: json["indicador_entrega_final"],
//         indicadorImpuesto: json["indicador_impuesto"],
//         esSerealizado: json["es_serealizado"],
//         esDevolucion: json["es_devolucion"],
//         solicitante: json["solicitante"],
//         series: List<dynamic>.from(json["series"].map((x) => x)),
//         cantidadFaltante: json["cantidad_faltante"],
//       );

//   Map<String, dynamic> toMap() => {
//         "umeSAP": umeSap,
//         "umeComercial": umeComercial,
//         "umeDescripcion": umeDescripcion,
//         "posicion": posicion,
//         "delete_indicador": deleteIndicador,
//         "numero_pedido": numeroPedido,
//         "numero_material": numeroMaterial,
//         "descripcion_material": descripcionMaterial,
//         "documento_material": documentoMaterial,
//         "documento_anio": documentoAnio,
//         "documento_pos": documentoPos,
//         "cantidad": cantidad,
//         "cantidad_recibida": cantidadRecibida,
//         "importe": importe,
//         "importe_recibido": importeRecibido,
//         "unidad_medida": unidadMedida,
//         "centro_receptor": centroReceptor,
//         "almacen": almacen,
//         "indicador_entrega_final": indicadorEntregaFinal,
//         "indicador_impuesto": indicadorImpuesto,
//         "es_serealizado": esSerealizado,
//         "es_devolucion": esDevolucion,
//         "solicitante": solicitante,
//         "series": List<dynamic>.from(series.map((x) => x)),
//         "cantidad_faltante": cantidadFaltante,
//       };
// }
