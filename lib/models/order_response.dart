import 'dart:convert';

class OrderResponse {
  OrderResponse({
    required this.code,
    required this.status,
    required this.pedidos,
  });

  int code;
  String status;
  List<Pedido> pedidos;

  factory OrderResponse.fromJson(String str) =>
      OrderResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderResponse.fromMap(Map<String, dynamic> json) => OrderResponse(
        code: json["code"],
        status: json["status"],
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toMap())),
      };
}

class Pedido {
  Pedido({
    required this.pedido,
    required this.numeroProveedor,
    required this.nombreProveedor,
    required this.fechaDocumento,
    required this.responsableSap,
    required this.importe,
    required this.grupoLiberacion,
    required this.codigoLiberacion,
    required this.posiciones,
  });

  String pedido;
  String numeroProveedor;
  String nombreProveedor;
  String fechaDocumento;
  String responsableSap;
  double importe;
  String grupoLiberacion;
  String codigoLiberacion;
  List<dynamic> posiciones;

  factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
        pedido: json["pedido"],
        numeroProveedor: json["numeroProveedor"],
        nombreProveedor: json["nombreProveedor"],
        fechaDocumento: json["fechaDocumento"],
        responsableSap: json["responsableSAP"],
        importe: json["importe"].toDouble(),
        grupoLiberacion: json["grupo_liberacion"],
        codigoLiberacion: json["codigo_liberacion"],
        posiciones: List<dynamic>.from(json["posiciones"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "pedido": pedido,
        "numeroProveedor": numeroProveedor,
        "nombreProveedor": nombreProveedor,
        "fechaDocumento": fechaDocumento,
        "responsableSAP": responsableSap,
        "importe": importe,
        "grupo_liberacion": grupoLiberacion,
        "codigo_liberacion": codigoLiberacion,
        "posiciones": List<dynamic>.from(posiciones.map((x) => x)),
      };
}

// enum OLiberacion { CB }

// final oLiberacionValues = EnumValues({"CB": OLiberacion.CB});

// enum ResponsableSap { ITSF_OAHP, ITSF_CARCAR, ITSF_DALG }

// final responsableSapValues = EnumValues({
//   "ITSF-CARCAR": ResponsableSap.ITSF_CARCAR,
//   "ITSF-DALG": ResponsableSap.ITSF_DALG,
//   "ITSF-OAHP": ResponsableSap.ITSF_OAHP
// });

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
