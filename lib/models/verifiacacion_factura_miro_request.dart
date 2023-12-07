import 'dart:convert';

import 'package:hope_app/models/models.dart';

class VerificacionFacturaMiroRequest {
  CabeceraPedidoMiro? cabeceraPedido;
  String documentoPedido;
  bool estatus;
  List<Historial> historial;
  List<dynamic>? mensajes;
  List<dynamic>? retenciones;
  String trace;
  List<Posicione> posiciones;
  double importeTotal;
  String fechaContabilizacion;
  String fechaFactura;

  VerificacionFacturaMiroRequest(
      {required this.cabeceraPedido,
      required this.documentoPedido,
      required this.estatus,
      required this.historial,
      this.mensajes,
      this.retenciones,
      required this.trace,
      required this.posiciones,
      required this.importeTotal,
      required this.fechaContabilizacion,
      required this.fechaFactura});

  factory VerificacionFacturaMiroRequest.fromJson(String str) =>
      VerificacionFacturaMiroRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerificacionFacturaMiroRequest.fromMap(Map<String, dynamic> json) =>
      VerificacionFacturaMiroRequest(
        fechaContabilizacion: json["fecha_contabilizacion"],
        fechaFactura: json["fechafactura"],
        cabeceraPedido: json["cabeceraPedido"] == null
            ? null
            : CabeceraPedidoMiro.fromMap(json["cabeceraPedido"]),
        documentoPedido: json["documento_pedido"],
        estatus: json["estatus"],
        historial: json["historial"] == null
            ? []
            : List<Historial>.from(
                json["historial"]!.map((x) => Historial.fromMap(x))),
        mensajes: json["mensajes"] == null
            ? []
            : List<dynamic>.from(json["mensajes"]!.map((x) => x)),
        retenciones: json["retenciones"] == null
            ? []
            : List<dynamic>.from(json["retenciones"]!.map((x) => x)),
        trace: json["trace"],
        posiciones: json["posiciones"] == null
            ? []
            : List<Posicione>.from(
                json["posiciones"]!.map((x) => Posicione.fromMap(x))),
        importeTotal: double.parse(json["importe_total"]),
      );

  Map<String, dynamic> toMap() => {
        "pedido": {
          "cabeceraPedido": cabeceraPedido?.toMap(),
          "documento_pedido": documentoPedido,
          "estatus": estatus,
          "historial": List<dynamic>.from(historial.map((x) => x.toMap())),
          "mensajes": mensajes == null
              ? []
              : List<dynamic>.from(mensajes!.map((x) => x)),
          "retenciones": retenciones == null
              ? []
              : List<dynamic>.from(retenciones!.map((x) => x)),
          "trace": trace,
          "posiciones": List<dynamic>.from(posiciones.map((x) => x.toMap())),
          "importe_total": importeTotal,
          "fecha_contabilizacion": fechaContabilizacion,
          "fecha_factura": fechaFactura,
        }
      };
}

class VerificacionFacturaMiroRequestResponse {
  bool? estatus;
  String? trace;
  String? timestamp;
  String? code;
  String documentoSap;
  String? indicador;
  String? tipoDocumento;
  String? fechaContabilizacion;
  String? fechaDocumento;
  String? nombreUsuario;
  String? textoCabecera;
  String? referencia;
  String? sociedad;
  String? emisor;
  String? moneda;
  dynamic total;
  dynamic calculaImpuesto;
  dynamic condicionPago;
  String? fechaVencimiento;
  List<Detalle>? detalles;
  List<dynamic>? retenciones;

  VerificacionFacturaMiroRequestResponse({
    this.estatus,
    this.trace,
    this.timestamp,
    this.code,
    required this.documentoSap,
    this.indicador,
    this.tipoDocumento,
    this.fechaContabilizacion,
    this.fechaDocumento,
    this.nombreUsuario,
    this.textoCabecera,
    this.referencia,
    this.sociedad,
    this.emisor,
    this.moneda,
    this.total,
    this.calculaImpuesto,
    this.condicionPago,
    this.fechaVencimiento,
    this.detalles,
    this.retenciones,
  });

  factory VerificacionFacturaMiroRequestResponse.fromJson(String str) =>
      VerificacionFacturaMiroRequestResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerificacionFacturaMiroRequestResponse.fromMap(
          Map<String, dynamic> json) =>
      VerificacionFacturaMiroRequestResponse(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"],
        code: json["code"],
        documentoSap: json["documento_sap"],
        indicador: json["indicador"],
        tipoDocumento: json["tipo_documento"],
        fechaContabilizacion: json["fecha_contabilizacion"],
        fechaDocumento: json["fecha_documento"],
        nombreUsuario: json["nombre_usuario"],
        textoCabecera: json["texto_cabecera"],
        referencia: json["referencia"],
        sociedad: json["sociedad"],
        emisor: json["emisor"],
        moneda: json["moneda"],
        total: json["total"],
        calculaImpuesto: json["calcula_impuesto"],
        condicionPago: json["condicion_pago"],
        fechaVencimiento: json["fecha_vencimiento"],
        detalles: json["detalles"] == []
            ? []
            : List<Detalle>.from(
                json["detalles"]!.map((x) => Detalle.fromMap(x))),
        retenciones: json["retenciones"] == []
            ? []
            : List<dynamic>.from(json["retenciones"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp": timestamp,
        "documento_sap": documentoSap,
        "indicador": indicador,
        "tipo_documento": tipoDocumento,
        "fecha_contabilizacion": fechaContabilizacion,
        "fecha_documento": fechaDocumento,
        "nombre_usuario": nombreUsuario,
        "texto_cabecera": textoCabecera,
        "referencia": referencia,
        "sociedad": sociedad,
        "emisor": emisor,
        "moneda": moneda,
        "total": total,
        "calcula_impuesto": calculaImpuesto,
        "condicion_pago": condicionPago,
        "fecha_vencimiento": fechaVencimiento,
        "detalles": detalles == []
            ? []
            : List<dynamic>.from(detalles!.map((x) => x.toMap())),
        "retenciones": retenciones == []
            ? []
            : List<dynamic>.from(retenciones!.map((x) => x)),
      };
}

class Detalle {
  dynamic posicion;
  dynamic numeroPedido;
  String? posicionPedido;
  String? documentoReferencia;
  String? documentoReferenciaAnio;
  String? documentoReferenciaIt;
  String? impuesto;
  dynamic importe;
  dynamic cantidad;
  String? unidadMedida;
  String? unidadMedidaUom;

  Detalle({
    this.posicion,
    this.numeroPedido,
    this.posicionPedido,
    this.documentoReferencia,
    this.documentoReferenciaAnio,
    this.documentoReferenciaIt,
    this.impuesto,
    this.importe,
    this.cantidad,
    this.unidadMedida,
    this.unidadMedidaUom,
  });

  factory Detalle.fromJson(String str) => Detalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Detalle.fromMap(Map<String, dynamic> json) => Detalle(
        posicion: json["posicion"],
        numeroPedido: json["numero_pedido"],
        posicionPedido: json["posicion_pedido"],
        documentoReferencia: json["documento_referencia"],
        documentoReferenciaAnio: json["documento_referencia_anio"],
        documentoReferenciaIt: json["documento_referencia_it"],
        impuesto: json["impuesto"],
        importe: json["importe"],
        cantidad: json["cantidad"],
        unidadMedida: json["unidad_medida"],
        unidadMedidaUom: json["unidad_medida_uom"],
      );

  Map<String, dynamic> toMap() => {
        "posicion": posicion,
        "numero_pedido": numeroPedido,
        "posicion_pedido": posicionPedido,
        "documento_referencia": documentoReferencia,
        "documento_referencia_anio": documentoReferenciaAnio,
        "documento_referencia_it": documentoReferenciaIt,
        "impuesto": impuesto,
        "importe": importe,
        "cantidad": cantidad,
        "unidad_medida": unidadMedida,
        "unidad_medida_uom": unidadMedidaUom,
      };
}
