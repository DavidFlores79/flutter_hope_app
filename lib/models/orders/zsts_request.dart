import 'dart:convert';

class CreateZstsRequest {
  Cabecera? cabeceraPedido;
  List<PedidoPos>? posiciones;

  CreateZstsRequest({
    this.cabeceraPedido,
    this.posiciones,
  });

  factory CreateZstsRequest.fromJson(String str) =>
      CreateZstsRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateZstsRequest.fromMap(Map<String, dynamic> json) =>
      CreateZstsRequest(
        cabeceraPedido: json["cabeceraPedido"] == null
            ? null
            : Cabecera.fromMap(json["cabeceraPedido"]),
        posiciones: json["posiciones"] == null
            ? []
            : List<PedidoPos>.from(
                json["posiciones"]!.map((x) => PedidoPos.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cabeceraPedido": cabeceraPedido?.toMap(),
        "posiciones": posiciones == null
            ? []
            : List<dynamic>.from(posiciones!.map((x) => x.toMap())),
      };
}

class Cabecera {
  int? gpoCompras;
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
  String? textoBreve;
  String? grupoCompras;
  String? centroReceptor;
  String? unidadMedida;
  String? claseDocumento;
  bool? esDevolucion;

  PedidoPos({
    this.cantidad,
    this.numeroMaterial,
    this.textoBreve,
    this.grupoCompras,
    this.centroReceptor,
    this.unidadMedida,
    this.claseDocumento,
    this.esDevolucion,
  });

  factory PedidoPos.fromJson(String str) => PedidoPos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoPos.fromMap(Map<String, dynamic> json) => PedidoPos(
        cantidad: json["cantidad"],
        numeroMaterial: json["numero_material"],
        textoBreve: json["texto_breve"],
        grupoCompras: json["grupo_compras"],
        centroReceptor: json["centro_receptor"],
        unidadMedida: json["unidad_medida"],
        claseDocumento: json["clase_documento"],
        esDevolucion: json["es_devolucion"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "numero_material": numeroMaterial,
        "texto_breve": textoBreve,
        "grupo_compras": grupoCompras,
        "centro_receptor": centroReceptor,
        "unidad_medida": unidadMedida,
        "clase_documento": claseDocumento,
        "es_devolucion": esDevolucion,
      };
}
