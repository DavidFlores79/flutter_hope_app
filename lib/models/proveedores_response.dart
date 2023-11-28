import 'dart:convert';

class SupplierSearchResponse {
    int? code;
    String? status;
    List<Supplier>? datos;

    SupplierSearchResponse({
        this.code,
        this.status,
        this.datos,
    });

    factory SupplierSearchResponse.fromJson(String str) => SupplierSearchResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SupplierSearchResponse.fromMap(Map<String, dynamic> json) => SupplierSearchResponse(
        code: json["code"],
        status: json["status"],
        datos: json["datos"] == null ? [] : List<Supplier>.from(json["datos"]!.map((x) => Supplier.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "datos": datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toMap())),
    };
}

class Supplier {
    String? numeroProveedor;
    String? nombres;

    Supplier({
        this.numeroProveedor,
        this.nombres,
    });

    factory Supplier.fromJson(String str) => Supplier.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Supplier.fromMap(Map<String, dynamic> json) => Supplier(
        numeroProveedor: json["numero_proveedor"],
        nombres: json["nombres"],
    );

    Map<String, dynamic> toMap() => {
        "numero_proveedor": numeroProveedor,
        "nombres": nombres,
    };
}
