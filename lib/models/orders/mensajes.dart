import 'dart:convert';

class Mensaje {
  String? tipoMensaje;
  String? claseMensaje;
  dynamic numeroMensaje;
  String? textoMensaje;
  String? variableMensaje;
  String? variableMensaje2;
  String? variableMensaje3;
  String? variableMensaje4;
  String? parametro;
  int? lineaParametro;
  String? campoParametro;
  String? sistemaProviene;

  Mensaje({
    this.tipoMensaje,
    this.claseMensaje,
    this.numeroMensaje,
    this.textoMensaje,
    this.variableMensaje,
    this.variableMensaje2,
    this.variableMensaje3,
    this.variableMensaje4,
    this.parametro,
    this.lineaParametro,
    this.campoParametro,
    this.sistemaProviene,
  });

  factory Mensaje.fromJson(String str) => Mensaje.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mensaje.fromMap(Map<String, dynamic> json) => Mensaje(
        tipoMensaje: json["tipo_mensaje"],
        claseMensaje: json["clase_mensaje"],
        numeroMensaje: json["numero_mensaje"],
        textoMensaje: json["texto_mensaje"],
        variableMensaje: json["variable_mensaje"],
        variableMensaje2: json["variable_mensaje2"],
        variableMensaje3: json["variable_mensaje3"],
        variableMensaje4: json["variable_mensaje4"],
        parametro: json["parametro"],
        lineaParametro: json["linea_parametro"],
        campoParametro: json["campo_parametro"],
        sistemaProviene: json["sistema_proviene"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_mensaje": tipoMensaje,
        "clase_mensaje": claseMensaje,
        "numero_mensaje": numeroMensaje,
        "texto_mensaje": textoMensaje,
        "variable_mensaje": variableMensaje,
        "variable_mensaje2": variableMensaje2,
        "variable_mensaje3": variableMensaje3,
        "variable_mensaje4": variableMensaje4,
        "parametro": parametro,
        "linea_parametro": lineaParametro,
        "campo_parametro": campoParametro,
        "sistema_proviene": sistemaProviene,
      };
}
