// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 20/02/2024
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class PurchaseRequestResponse {
  int? code;
  String? status;
  List<DocumentLine>? data;
  List<SupplierSBO>? suppliers;

  PurchaseRequestResponse({
    this.code,
    this.status,
    this.data,
    this.suppliers,
  });

  factory PurchaseRequestResponse.fromJson(String str) =>
      PurchaseRequestResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseRequestResponse.fromMap(Map<String, dynamic> json) =>
      PurchaseRequestResponse(
        code: json["code"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<DocumentLine>.from(
                json["data"]!.map((x) => DocumentLine.fromMap(x))),
        suppliers: json["suppliers"] == null
            ? []
            : List<SupplierSBO>.from(
                json["suppliers"]!.map((x) => SupplierSBO.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "suppliers": suppliers == null
            ? []
            : List<dynamic>.from(suppliers!.map((x) => x.toMap())),
      };
}

class DocumentLine {
  int? id;
  int? userId;
  int? statusId;
  int? companyId;
  dynamic trgetEntry;
  dynamic docEntry;
  int? lineNum;
  String? itemCode;
  String? itemDescription;
  String? quantity;
  String? warehouseCode;
  dynamic lineVendor;
  dynamic taxCode;
  String? inventoryUom;
  String? price;
  dynamic rejectionText;
  String? comments;
  bool? modified;
  String? createdBy;
  dynamic releasedBy;
  String? requestedAt;
  dynamic releasedAt;
  String? deliveredAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Estatus? status;

  DocumentLine({
    this.id,
    this.userId,
    this.statusId,
    this.companyId,
    this.trgetEntry,
    this.docEntry,
    this.lineNum,
    this.itemCode,
    this.itemDescription,
    this.quantity,
    this.warehouseCode,
    this.lineVendor,
    this.taxCode,
    this.inventoryUom,
    this.price,
    this.rejectionText,
    this.comments,
    this.modified,
    this.createdBy,
    this.releasedBy,
    this.requestedAt,
    this.releasedAt,
    this.deliveredAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory DocumentLine.fromJson(String str) =>
      DocumentLine.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocumentLine.fromMap(Map<String, dynamic> json) => DocumentLine(
        id: json["id"],
        userId: json["user_id"],
        statusId: json["status_id"],
        companyId: json["company_id"],
        trgetEntry: json["trget_entry"],
        docEntry: json["doc_entry"],
        lineNum: json["line_num"],
        itemCode: json["item_code"],
        itemDescription: json["item_description"],
        quantity: json["quantity"],
        warehouseCode: json["warehouse_code"],
        lineVendor: json["line_vendor"],
        taxCode: json["tax_code"],
        inventoryUom: json["inventory_uom"],
        price: json["price"],
        rejectionText: json["rejection_text"],
        comments: json["comments"],
        modified: json["modified"],
        createdBy: json["created_by"],
        releasedBy: json["released_by"],
        requestedAt: json["requested_at"],
        releasedAt: json["released_at"],
        deliveredAt: json["delivered_at"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"] == null ? null : Estatus.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "status_id": statusId,
        "company_id": companyId,
        "trget_entry": trgetEntry,
        "doc_entry": docEntry,
        "line_num": lineNum,
        "item_code": itemCode,
        "item_description": itemDescription,
        "quantity": quantity,
        "warehouse_code": warehouseCode,
        "line_vendor": lineVendor,
        "tax_code": taxCode,
        "inventory_uom": inventoryUom,
        "price": price,
        "rejection_text": rejectionText,
        "comments": comments,
        "modified": modified,
        "created_by": createdBy,
        "released_by": releasedBy,
        "requested_at": requestedAt,
        "released_at": releasedAt,
        "delivered_at": deliveredAt,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status?.toMap(),
      };
}

class StorePurchaseReqResponse {
  int? code;
  String? status;
  String? message;
  DocumentLine? data;

  StorePurchaseReqResponse({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory StorePurchaseReqResponse.fromJson(String str) =>
      StorePurchaseReqResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StorePurchaseReqResponse.fromMap(Map<String, dynamic> json) =>
      StorePurchaseReqResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DocumentLine.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data?.toMap(),
      };
}
