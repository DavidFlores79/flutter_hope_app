import 'dart:convert';

class VerificacionFacturaMiroResponse {
  int? code;
  String? message;
  String? status;
  PedidoMiro? pedidoMiro;
  String? userlog;

  VerificacionFacturaMiroResponse({
    this.code,
    this.message,
    this.status,
    this.pedidoMiro,
    this.userlog,
  });

  factory VerificacionFacturaMiroResponse.fromJson(String str) =>
      VerificacionFacturaMiroResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerificacionFacturaMiroResponse.fromMap(Map<String, dynamic> json) =>
      VerificacionFacturaMiroResponse(
        code: json["code"],
        message: json["message"],
        status: json["status"],
        pedidoMiro: json["respuesta"] == null
            ? null
            : PedidoMiro.fromMap(json["respuesta"]),
        userlog: json["userlog"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "status": status,
        "respuesta": pedidoMiro?.toMap(),
        "userlog": userlog,
      };
}

class PedidoMiro {
  CabeceraPedidoMiro? cabeceraPedido;
  String? documentoPedido;
  bool? estatus;
  List<Historial>? historial;
  List<dynamic>? mensajes;
  List<dynamic>? retenciones;
  String? trace;
  List<Posicione>? posiciones;
  double? importeTotal;

  PedidoMiro({
    this.cabeceraPedido,
    this.documentoPedido,
    this.estatus,
    this.historial,
    this.mensajes,
    this.retenciones,
    this.trace,
    this.posiciones,
    this.importeTotal,
  });

  factory PedidoMiro.fromJson(String str) =>
      PedidoMiro.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoMiro.fromMap(Map<String, dynamic> json) => PedidoMiro(
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
        importeTotal: json["importe_total"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "cabeceraPedido": cabeceraPedido?.toMap(),
        "documento_pedido": documentoPedido,
        "estatus": estatus,
        "historial": historial == null
            ? []
            : List<dynamic>.from(historial!.map((x) => x.toMap())),
        "mensajes":
            mensajes == null ? [] : List<dynamic>.from(mensajes!.map((x) => x)),
        "retenciones": retenciones == null
            ? []
            : List<dynamic>.from(retenciones!.map((x) => x)),
        "trace": trace,
        "posiciones": posiciones == null
            ? []
            : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
        "importe_total": importeTotal,
      };
}

class CabeceraPedidoMiro {
  String? sociedad;
  String? indicadorBorrado;
  String? fechaCreacionRegistro;
  String? responsableCreacion;
  String? cuentaProveedor;
  dynamic proveedorMercancias;
  String? fechaDocumentoCompras;
  String? referencia;
  String? centroSuministrador;
  String? numeroPedido;
  dynamic tipoPedido;
  dynamic orgCompras;
  dynamic gpoCompras;
  String? moneda;
  String? clavePago;
  bool? seVerifica;
  dynamic nuestraReferencia;
  dynamic claseDocumento;

  CabeceraPedidoMiro({
    this.sociedad,
    this.indicadorBorrado,
    this.fechaCreacionRegistro,
    this.responsableCreacion,
    this.cuentaProveedor,
    this.proveedorMercancias,
    this.fechaDocumentoCompras,
    this.referencia,
    this.centroSuministrador,
    this.numeroPedido,
    this.tipoPedido,
    this.orgCompras,
    this.gpoCompras,
    this.moneda,
    this.clavePago,
    this.seVerifica,
    this.nuestraReferencia,
    this.claseDocumento,
  });

  factory CabeceraPedidoMiro.fromJson(String str) =>
      CabeceraPedidoMiro.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CabeceraPedidoMiro.fromMap(Map<String, dynamic> json) =>
      CabeceraPedidoMiro(
        sociedad: json["sociedad"],
        indicadorBorrado: json["indicador_borrado"],
        fechaCreacionRegistro: json["fecha_creacion_registro"],
        responsableCreacion: json["responsable_creacion"],
        cuentaProveedor: json["cuenta_proveedor"],
        proveedorMercancias: json["proveedor_mercancias"],
        fechaDocumentoCompras: json["fecha_documento_compras"],
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
        "fecha_creacion_registro": fechaCreacionRegistro,
        "responsable_creacion": responsableCreacion,
        "cuenta_proveedor": cuentaProveedor,
        "proveedor_mercancias": proveedorMercancias,
        "fecha_documento_compras": fechaDocumentoCompras,
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

class Historial {
  String? umeSap;
  String? umeComercial;
  String? umeDescripcion;
  int? posicion;
  String? posicionText;
  String? documentoMaterial;
  String? documentoAnio;
  String? documentoPos;
  String? numeroMaterial;
  String? tipo;
  String? tipoMovimiento;
  double? cantidad;
  double? importe;
  String? unidadMedida;
  String? centroReceptor;

  Historial({
    this.umeSap,
    this.umeComercial,
    this.umeDescripcion,
    this.posicion,
    this.posicionText,
    this.documentoMaterial,
    this.documentoAnio,
    this.documentoPos,
    this.numeroMaterial,
    this.tipo,
    this.tipoMovimiento,
    this.cantidad,
    this.importe,
    this.unidadMedida,
    this.centroReceptor,
  });

  factory Historial.fromJson(String str) => Historial.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Historial.fromMap(Map<String, dynamic> json) => Historial(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        posicion: json["posicion"],
        posicionText: json["posicion_text"],
        documentoMaterial: json["documento_material"],
        documentoAnio: json["documento_anio"],
        documentoPos: json["documento_pos"],
        numeroMaterial: json["numero_material"],
        tipo: json["tipo"],
        tipoMovimiento: json["tipo_movimiento"],
        cantidad: json["cantidad"]?.toDouble(),
        importe: json["importe"]?.toDouble(),
        unidadMedida: json["unidad_medida"],
        centroReceptor: json["centro_receptor"],
      );

  Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "posicion": posicion,
        "posicion_text": posicionText,
        "documento_material": documentoMaterial,
        "documento_anio": documentoAnio,
        "documento_pos": documentoPos,
        "numero_material": numeroMaterial,
        "tipo": tipo,
        "tipo_movimiento": tipoMovimiento,
        "cantidad": cantidad,
        "importe": importe,
        "unidad_medida": unidadMedida,
        "centro_receptor": centroReceptor,
      };
}

class Posicione {
  bool isSelected = false;
  String? umeSap;
  String? umeComercial;
  String? umeDescripcion;
  int? posicion;
  String? posicionText;
  String? documentoMaterial;
  String? documentoAnio;
  String? documentoPos;
  String? numeroMaterial;
  String? tipo;
  String? tipoMovimiento;
  double? cantidad;
  double? importe;
  String? unidadMedida;
  String? centroReceptor;
  int? verificacion;
  double? importeRecibido;
  String? descripcionMaterial;
  String? numeroPedido;
  String? almacen;
  String? indicadorImpuesto;

  Posicione({
    this.umeSap,
    this.umeComercial,
    this.umeDescripcion,
    this.posicion,
    this.posicionText,
    this.documentoMaterial,
    this.documentoAnio,
    this.documentoPos,
    this.numeroMaterial,
    this.tipo,
    this.tipoMovimiento,
    this.cantidad,
    this.importe,
    this.unidadMedida,
    this.centroReceptor,
    this.verificacion,
    this.importeRecibido,
    this.descripcionMaterial,
    this.numeroPedido,
    this.almacen,
    this.indicadorImpuesto,
  });

  factory Posicione.fromJson(String str) => Posicione.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Posicione.fromMap(Map<String, dynamic> json) => Posicione(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        posicion: json["posicion"],
        posicionText: json["posicion_text"],
        documentoMaterial: json["documento_material"],
        documentoAnio: json["documento_anio"],
        documentoPos: json["documento_pos"],
        numeroMaterial: json["numero_material"],
        tipo: json["tipo"],
        tipoMovimiento: json["tipo_movimiento"],
        cantidad: json["cantidad"]?.toDouble(),
        importe: json["importe"]?.toDouble(),
        unidadMedida: json["unidad_medida"],
        centroReceptor: json["centro_receptor"],
        verificacion: json["verificacion"],
        importeRecibido: json["importe_recibido"]?.toDouble(),
        descripcionMaterial: json["descripcion_material"],
        numeroPedido: json["numero_pedido"],
        almacen: json["almacen"],
        indicadorImpuesto: json["indicador_impuesto"],
      );

  Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "posicion": posicion,
        "posicion_text": posicionText,
        "documento_material": documentoMaterial,
        "documento_anio": documentoAnio,
        "documento_pos": documentoPos,
        "numero_material": numeroMaterial,
        "tipo": tipo,
        "tipo_movimiento": tipoMovimiento,
        "cantidad": cantidad,
        "importe": importe,
        "unidad_medida": unidadMedida,
        "centro_receptor": centroReceptor,
        "verificacion": verificacion,
        "importe_recibido": importeRecibido,
        "descripcion_material": descripcionMaterial,
        "numero_pedido": numeroPedido,
        "almacen": almacen,
        "indicador_impuesto": indicadorImpuesto,
      };
}
