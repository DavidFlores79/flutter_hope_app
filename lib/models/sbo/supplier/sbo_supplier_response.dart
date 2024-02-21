// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 20/02/2024
 */
import 'dart:convert';

class SupplierSBO {
  String? odataEtag;
  String? cardCode;
  String? cardName;
  String? cardType;

  SupplierSBO({
    this.odataEtag,
    this.cardCode,
    this.cardName,
    this.cardType,
  });

  factory SupplierSBO.fromJson(String str) =>
      SupplierSBO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierSBO.fromMap(Map<String, dynamic> json) => SupplierSBO(
        odataEtag: json["odata.etag"],
        cardCode: json["CardCode"],
        cardName: json["CardName"],
        cardType: json["CardType"],
      );

  Map<String, dynamic> toMap() => {
        "odata.etag": odataEtag,
        "CardCode": cardCode,
        "CardName": cardName,
        "CardType": cardType,
      };
}
