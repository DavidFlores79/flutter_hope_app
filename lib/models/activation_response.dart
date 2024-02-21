// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 08/12/2022
 */

import 'dart:convert';

ActivationResponse activationResponseFromMap(String str) =>
    ActivationResponse.fromMap(json.decode(str));

String activationResponseToMap(ActivationResponse data) =>
    json.encode(data.toMap());

class ActivationResponse {
  ActivationResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.license,
    required this.clientImage,
    this.sapCode,
  });

  int code;
  String status;
  String message;
  License license;
  String clientImage;
  String? sapCode;

  factory ActivationResponse.fromMap(Map<String, dynamic> json) =>
      ActivationResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        license: License.fromMap(json["license"]),
        clientImage: json["client_image"],
        sapCode: json["sap_code"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "license": license.toMap(),
        "client_image": clientImage,
        "sap_code": sapCode,
      };
}

class License {
  License({
    required this.id,
    required this.applicationId,
    required this.clientId,
    required this.activationCode,
    this.urlApi,
    required this.status,
    required this.startDate,
    required this.finalDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int applicationId;
  int clientId;
  String activationCode;
  dynamic urlApi;
  int status;
  String startDate;
  String finalDate;
  String createdAt;
  String updatedAt;

  factory License.fromMap(Map<String, dynamic> json) => License(
        id: json["id"],
        applicationId: json["application_id"],
        clientId: json["client_id"],
        activationCode: json["activation_code"],
        urlApi: json["url_api"],
        status: json["status"],
        startDate: json["start_date"],
        finalDate: json["final_date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "application_id": applicationId,
        "client_id": clientId,
        "activation_code": activationCode,
        "url_api": urlApi,
        "status": status,
        "start_date": startDate,
        "final_date": finalDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
