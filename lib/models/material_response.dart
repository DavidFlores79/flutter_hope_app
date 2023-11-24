import 'dart:convert';

class MaterialResponse {
  bool? estatus;
  String? trace;
  DateTime? timestamp;
  String? code;
  String? numeroMaterial;
  String? textoBreve;
  List<Materials>? materials;

  MaterialResponse({
    this.estatus,
    this.trace,
    this.timestamp,
    this.code,
    this.numeroMaterial,
    this.textoBreve,
    this.materials,
  });

  factory MaterialResponse.fromJson(String str) =>
      MaterialResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MaterialResponse.fromMap(Map<String, dynamic> json) =>
      MaterialResponse(
        estatus: json["estatus"],
        trace: json["trace"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        code: json["code"],
        numeroMaterial: json["numero_material"],
        textoBreve: json["texto_breve"],
        materials: json["materiales"] == null
            ? []
            : List<Materials>.from(
                json["materiales"]!.map((x) => Materials.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "trace": trace,
        "timestamp":
            "${timestamp!.year.toString().padLeft(4, '0')}-${timestamp!.month.toString().padLeft(2, '0')}-${timestamp!.day.toString().padLeft(2, '0')}",
        "code": code,
        "numero_material": numeroMaterial,
        "texto_breve": textoBreve,
        "materiales": materials == null
            ? []
            : List<dynamic>.from(materials!.map((x) => x.toMap())),
      };
}

class Materials {
  String? umeSap;
  String? umeComercial;
  String? umeDescripcion;
  String? numeroMaterial;
  String? textoBreve;
  String? tipoMaterial;
  String? unidadMedida;
  String? unidadMedidaTexto;
  String? grupoArticulo;
  String? grupoCompras;
  String? cuentamayor;
  String? numConversion;
  String? denConversion;
  String? unidadMedidaVisual;

  Materials({
    this.umeSap,
    this.umeComercial,
    this.umeDescripcion,
    this.numeroMaterial,
    this.textoBreve,
    this.tipoMaterial,
    this.unidadMedida,
    this.unidadMedidaTexto,
    this.grupoArticulo,
    this.grupoCompras,
    this.cuentamayor,
    this.numConversion,
    this.denConversion,
    this.unidadMedidaVisual,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Materials &&
        other.tipoMaterial == tipoMaterial &&
        other.numeroMaterial == numeroMaterial;
  }

  @override
  int get hashCode => tipoMaterial.hashCode ^ numeroMaterial.hashCode;

  factory Materials.fromJson(String str) => Materials.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Materials.fromMap(Map<String, dynamic> json) => Materials(
        umeSap: json["umeSAP"],
        umeComercial: json["umeComercial"],
        umeDescripcion: json["umeDescripcion"],
        numeroMaterial: json["numero_material"],
        textoBreve: json["texto_breve"],
        tipoMaterial: json["tipo_material"],
        unidadMedida: json["unidad_medida"],
        unidadMedidaTexto: json["unidad_medida_texto"],
        grupoArticulo: json["grupo_articulo"],
        grupoCompras: json["grupo_compras"],
        cuentamayor: json["cuentamayor"],
        numConversion: json["num_conversion"],
        denConversion: json["den_conversion"],
        unidadMedidaVisual: json["unidad_medida_visual"],
      );

  Map<String, dynamic> toMap() => {
        "umeSAP": umeSap,
        "umeComercial": umeComercial,
        "umeDescripcion": umeDescripcion,
        "numero_material": numeroMaterial,
        "texto_breve": textoBreve,
        "tipo_material": tipoMaterial,
        "unidad_medida": unidadMedida,
        "unidad_medida_texto": unidadMedidaTexto,
        "grupo_articulo": grupoArticulo,
        "grupo_compras": grupoCompras,
        "cuentamayor": cuentamayor,
        "num_conversion": numConversion,
        "den_conversion": denConversion,
        "unidad_medida_visual": unidadMedidaVisual,
      };
}
