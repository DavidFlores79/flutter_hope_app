// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromMap(jsonString);

import 'dart:convert';

class ErrorResponse {
  ErrorResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.success,
  });

  int code;
  String status;
  String message;
  bool success;

  factory ErrorResponse.fromJson(String str) =>
      ErrorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorResponse.fromMap(Map<String, dynamic> json) => ErrorResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "success": success,
      };
}
