// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 05/12/2023
 */

import 'dart:convert';

class TransferenciaInterna {
    String? referencia;
    A? de;
    A? a;
    String? hashKey;

    TransferenciaInterna({
        this.referencia,
        this.de,
        this.a,
        this.hashKey,
    });

    factory TransferenciaInterna.fromJson(String str) => TransferenciaInterna.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TransferenciaInterna.fromMap(Map<String, dynamic> json) => TransferenciaInterna(
        referencia: json["referencia"],
        de: json["de"] == null ? null : A.fromMap(json["de"]),
        a: json["a"] == null ? null : A.fromMap(json["a"]),
        hashKey: json["\u0024\u0024hashKey"],
    );

    Map<String, dynamic> toMap() => {
        "referencia": referencia,
        "de": de?.toMap(),
        "a": a?.toMap(),
        "\u0024\u0024hashKey": hashKey,
    };
}

class A {
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
    String? hashKey;
    String? almacen;
    int? cantidad;

    A({
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
        this.hashKey,
        this.almacen,
        this.cantidad,
    });

    factory A.fromJson(String str) => A.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory A.fromMap(Map<String, dynamic> json) => A(
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
        hashKey: json["\u0024\u0024hashKey"],
        almacen: json["almacen"],
        cantidad: json["cantidad"],
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
        "\u0024\u0024hashKey": hashKey,
        "almacen": almacen,
        "cantidad": cantidad,
    };
}
