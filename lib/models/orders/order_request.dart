import 'dart:convert';

class CreateOrderRequest {
  PedidoME21N? pedido;

  CreateOrderRequest({
    this.pedido,
  });

  factory CreateOrderRequest.fromJson(String str) =>
      CreateOrderRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateOrderRequest.fromMap(Map<String, dynamic> json) =>
      CreateOrderRequest(
        pedido:
            json["pedido"] == null ? null : PedidoME21N.fromMap(json["pedido"]),
      );

  Map<String, dynamic> toMap() => {
        "pedido": pedido?.toMap(),
      };
}

class PedidoME21N {
  Cabecera? cabeceraPedido;
  List<PosicionZSTT>? posiciones;

  PedidoME21N({
    this.cabeceraPedido,
    this.posiciones,
  });

  factory PedidoME21N.fromJson(String str) =>
      PedidoME21N.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoME21N.fromMap(Map<String, dynamic> json) => PedidoME21N(
        cabeceraPedido: json["cabeceraPedido"] == null
            ? null
            : Cabecera.fromMap(json["cabeceraPedido"]),
        posiciones: json["posiciones"] == null
            ? []
            : List<PosicionZSTT>.from(
                json["posiciones"]!.map((x) => PosicionZSTT.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cabeceraPedido": cabeceraPedido?.toMap(),
        "posiciones": posiciones == null
            ? []
            : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
      };
}

class Cabecera {
  String? gpoCompras;
  String? tipoPedido;
  dynamic nuestraReferencia;
    String? cuentaProveedor;
    String? proveedorMercancias;
    String? orgCompras;

  Cabecera({
    this.gpoCompras,
    this.tipoPedido,
    this.nuestraReferencia,
        this.cuentaProveedor,
        this.proveedorMercancias,
        this.orgCompras,
  });

  factory Cabecera.fromJson(String str) => Cabecera.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cabecera.fromMap(Map<String, dynamic> json) => Cabecera(
        gpoCompras: json["gpo_compras"],
        tipoPedido: json["tipo_pedido"],
        nuestraReferencia: json["nuestra_referencia"],
        cuentaProveedor: json["cuenta_proveedor"],
        proveedorMercancias: json["proveedor_mercancias"],
        orgCompras: json["org_compras"],
      );

  Map<String, dynamic> toMap() => {
        "gpo_compras": gpoCompras,
        "tipo_pedido": tipoPedido,
        "nuestra_referencia": nuestraReferencia,
        "cuenta_proveedor": cuentaProveedor,
        "proveedor_mercancias": proveedorMercancias,
        "org_compras": orgCompras,
      };
}

class PedidoPos {
  String? cantidad;
  String? numeroMaterial;
  String? centroReceptor;
  String? unidadMedida;
  String? textoBreve;
  String? grupoCompras;
  String? claseDocumento;
  bool? esDevolucion;
  String? almacen;

  PedidoPos({
    this.cantidad,
    this.numeroMaterial,
    this.centroReceptor,
    this.unidadMedida,
    this.textoBreve,
    this.grupoCompras,
    this.claseDocumento,
    this.esDevolucion,
    this.almacen,
  });

  factory PedidoPos.fromJson(String str) => PedidoPos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoPos.fromMap(Map<String, dynamic> json) => PedidoPos(
        cantidad: json["cantidad"],
        numeroMaterial: json["numero_material"],
        centroReceptor: json["centro_receptor"],
        unidadMedida: json["unidad_medida"],
        textoBreve: json["texto_breve"],
        grupoCompras: json["grupo_compras"],
        claseDocumento: json["clase_documento"],
        esDevolucion: json["es_devolucion"],
        almacen: json["almacen"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "numero_material": numeroMaterial,
        "centro_receptor": centroReceptor,
        "unidad_medida": unidadMedida,
        "texto_breve": textoBreve,
        "grupo_compras": grupoCompras,
        "clase_documento": claseDocumento,
        "es_devolucion": esDevolucion,
        "almacen": almacen,
      };
}

class PosicionZSTT {
  String? cantidad;
  String? numeroMaterial;
  String? centroReceptor;
  String? unidadMedida;
  bool? esDevolucion;
  String? almacen;

  PosicionZSTT({
    this.cantidad,
    this.numeroMaterial,
    this.centroReceptor,
    this.unidadMedida,
    this.esDevolucion,
    this.almacen
  });

  factory PosicionZSTT.fromJson(String str) =>
      PosicionZSTT.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PosicionZSTT.fromMap(Map<String, dynamic> json) => PosicionZSTT(
        cantidad: json["cantidad"],
        numeroMaterial: json["numero_material"],
        centroReceptor: json["centro_receptor"],
        unidadMedida: json["unidad_medida"],
        esDevolucion: json["es_devolucion"],
        almacen: json["almacen"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "numero_material": numeroMaterial,
        "centro_receptor": centroReceptor,
        "unidad_medida": unidadMedida,
        "es_devolucion": esDevolucion,
        "almacen": almacen,
      };
}
