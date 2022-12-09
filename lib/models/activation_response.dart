// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 08/12/2022
 */

import 'dart:convert';

// class ActivationResponse {
//   ActivationResponse({
//     required this.code,
//     required this.status,
//     required this.message,
//     required this.license,
//   });

//   int code;
//   String status;
//   String message;
//   License license;

//   factory ActivationResponse.fromJson(String str) =>
//       ActivationResponse.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory ActivationResponse.fromMap(Map<String, dynamic> json) =>
//       ActivationResponse(
//         code: json["code"],
//         status: json["status"],
//         message: json["message"],
//         license: License.fromMap(json["license"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "code": code,
//         "status": status,
//         "message": message,
//         "license": license.toMap(),
//       };
// }

// class License {
//   License({
//     required this.id,
//     required this.applicationId,
//     required this.clientId,
//     required this.activationCode,
//     required this.status,
//     required this.startDate,
//     required this.finalDate,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   int id;
//   int applicationId;
//   int clientId;
//   String activationCode;
//   int status;
//   String startDate;
//   String finalDate;
//   String createdAt;
//   String updatedAt;

//   factory License.fromJson(String str) => License.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory License.fromMap(Map<String, dynamic> json) => License(
//         id: json["id"],
//         applicationId: json["application_id"],
//         clientId: json["client_id"],
//         activationCode: json["activation_code"],
//         status: json["status"],
//         startDate: json["start_date"],
//         finalDate: json["final_date"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "application_id": applicationId,
//         "client_id": clientId,
//         "activation_code": activationCode,
//         "status": status,
//         "start_date": startDate,
//         "final_date": finalDate,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };

//   // factory License.fromMap(Map<String, dynamic> json) => License(
//   //       id: json["id"],
//   //       applicationId: json["application_id"],
//   //       clientId: json["client_id"],
//   //       activationCode: json["activation_code"],
//   //       status: json["status"],
//   //       startDate: json["start_date"],
//   //       finalDate: json["final_date"],
//   //       createdAt: json["created_at"],
//   //       updatedAt: json["updated_at"],
//   //     );

//   // Map<String, dynamic> toMap() => {
//   //       "id": id,
//   //       "application_id": applicationId,
//   //       "client_id": clientId,
//   //       "activation_code": activationCode,
//   //       "status": status,
//   //       "start_date": startDate,
//   //       "final_date": finalDate,
//   //       "created_at": createdAt,
//   //       "updated_at": updatedAt,
//   //     };
// }

// class Url {
//   Url({
//     required this.dominio,
//     required this.path,
//   });

//   String dominio;
//   String path;

//   factory Url.fromMap(Map<String, dynamic> json) => Url(
//         dominio: json["dominio"],
//         path: json["path"],
//       );

//   Map<String, dynamic> toMap() => {
//         "dominio": dominio,
//         "path": path,
//       };
// }

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
    required this.url,
  });

  int code;
  String status;
  String message;
  License license;
  Url url;

  factory ActivationResponse.fromMap(Map<String, dynamic> json) =>
      ActivationResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        license: License.fromMap(json["license"]),
        url: Url.fromMap(json["url"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "license": license.toMap(),
        "url": url.toMap(),
      };
}

class License {
  License({
    required this.id,
    required this.applicationId,
    required this.clientId,
    required this.activationCode,
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
        "status": status,
        "start_date": startDate,
        "final_date": finalDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Url {
  Url({
    required this.dominio,
    required this.path,
  });

  String dominio;
  String path;

  factory Url.fromMap(Map<String, dynamic> json) => Url(
        dominio: json["dominio"],
        path: json["path"],
      );

  Map<String, dynamic> toMap() => {
        "dominio": dominio,
        "path": path,
      };
}
