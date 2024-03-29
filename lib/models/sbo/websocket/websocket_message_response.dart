// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 23/02/2024
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class WebsocketMessage {
  String? type;
  DocumentLine? data;

  WebsocketMessage({
    this.type,
    this.data,
  });

  factory WebsocketMessage.fromJson(String str) =>
      WebsocketMessage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WebsocketMessage.fromMap(Map<String, dynamic> json) =>
      WebsocketMessage(
        type: json["type"],
        data: json["data"] == null ? null : DocumentLine.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "data": data?.toMap(),
      };
}

class WSDocumentLineList {
  String? type;
  List<DocumentLine>? data;

  WSDocumentLineList({
    this.type,
    this.data,
  });

  factory WSDocumentLineList.fromJson(String str) =>
      WSDocumentLineList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WSDocumentLineList.fromMap(Map<String, dynamic> json) =>
      WSDocumentLineList(
        type: json["type"],
        data: json["data"] == null
            ? []
            : List<DocumentLine>.from(
                json["data"]!.map((x) => DocumentLine.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
