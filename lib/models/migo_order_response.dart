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
