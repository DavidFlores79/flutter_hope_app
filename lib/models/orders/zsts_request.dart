import 'dart:convert';

class CreateZstsRequest {
  PedidoME21N? pedido;

  CreateZstsRequest({
    this.pedido,
  });

  factory CreateZstsRequest.fromJson(String str) =>
      CreateZstsRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateZstsRequest.fromMap(Map<String, dynamic> json) =>
      CreateZstsRequest(
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

  Cabecera({
    this.gpoCompras,
    this.tipoPedido,
  });

  factory Cabecera.fromJson(String str) => Cabecera.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cabecera.fromMap(Map<String, dynamic> json) => Cabecera(
        gpoCompras: json["gpo_compras"],
        tipoPedido: json["tipo_pedido"],
      );

  Map<String, dynamic> toMap() => {
        "gpo_compras": gpoCompras,
        "tipo_pedido": tipoPedido,
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

  PedidoPos({
    this.cantidad,
    this.numeroMaterial,
    this.centroReceptor,
    this.unidadMedida,
    this.textoBreve,
    this.grupoCompras,
    this.claseDocumento,
    this.esDevolucion,
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
      };
}

class PosicionZSTT {
  String? cantidad;
  String? numeroMaterial;
  String? centroReceptor;
  String? unidadMedida;
  bool? esDevolucion;

  PosicionZSTT({
    this.cantidad,
    this.numeroMaterial,
    this.centroReceptor,
    this.unidadMedida,
    this.esDevolucion,
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
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "numero_material": numeroMaterial,
        "centro_receptor": centroReceptor,
        "unidad_medida": unidadMedida,
        "es_devolucion": esDevolucion,
      };
}
