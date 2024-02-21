// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 20/02/2024
 */
import 'dart:convert';

class SBOWarehousesResponse {
  String? odataMetadata;
  List<SBO_Warehouse>? value;

  SBOWarehousesResponse({
    this.odataMetadata,
    this.value,
  });

  factory SBOWarehousesResponse.fromJson(String str) =>
      SBOWarehousesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SBOWarehousesResponse.fromMap(Map<String, dynamic> json) =>
      SBOWarehousesResponse(
        odataMetadata: json["odata.metadata"],
        value: json["value"] == null
            ? []
            : List<SBO_Warehouse>.from(
                json["value"]!.map((x) => SBO_Warehouse.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "odata.metadata": odataMetadata,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toMap())),
      };
}

class SBO_Warehouse {
  String? warehouseCode;
  String? warehouseName;
  String? inactive;

  SBO_Warehouse({
    this.warehouseCode,
    this.warehouseName,
    this.inactive,
  });

  factory SBO_Warehouse.fromJson(String str) =>
      SBO_Warehouse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SBO_Warehouse.fromMap(Map<String, dynamic> json) => SBO_Warehouse(
        warehouseCode: json["WarehouseCode"],
        warehouseName: json["WarehouseName"],
        inactive: json["Inactive"],
      );

  Map<String, dynamic> toMap() => {
        "WarehouseCode": warehouseCode,
        "WarehouseName": warehouseName,
        "Inactive": inactive,
      };
}
