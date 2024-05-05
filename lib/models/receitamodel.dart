import 'dart:convert';
import 'dart:ui';

import 'package:chat_gemini/models/database.dart';

class ReceitaModel implements DBModel {
  int? id;
  String? key;
  String nomeReceita;
  String? descricao;
  String? image;
  int? numPorcoes;
  int? tempo;
  String? categoria;
  int? avaliacao;
  List<String> ingredientes;
  List<String> modoPreparo;
  DateTime? createdAt;

  ReceitaModel(
      {this.id,
       this.key,
      required this.nomeReceita,
      this.descricao,
      this.image,
      this.numPorcoes,
      this.tempo,
      this.categoria,
      this.avaliacao,
      required this.ingredientes,
      required this.modoPreparo,
      this.createdAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "nomeReceita": nomeReceita,
      "descricao": descricao,
      "image": image,
      "numPorcoes": numPorcoes,
      "tempo": tempo,
      "categoria": categoria,
      "avaliacao": avaliacao,
      "ingredientes": jsonEncode(ingredientes),
      "modoDePreparo": jsonEncode(modoPreparo)
    };
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
        id: (map["id"] != null) ? map["id"] : -1,
        key: map["key"],
        nomeReceita: map["nomeReceita"],
        descricao: map["descricao"],
        image: map["image"],
        numPorcoes: map["numPorcoes"],
        tempo: map["tempo"],
        categoria: map["categoria"],
        avaliacao: (map["avaliacao"] != null) ? map["avaliacao"] : 3,
        ingredientes: (map["ingredientes"] is String) ? map["ingredientes"].split(",") : List<String>.from(map["ingredientes"]),
        modoPreparo: (map["modoDePreparo"] is String) ? map["modoDePreparo"].split(",") : List<String>.from(map["modoDePreparo"]),
        createdAt: (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]) : DateTime.now());
  }

  static List<ReceitaModel> listaReceitas(List<dynamic> receitas) {
    List<ReceitaModel> result = receitas
        .map((receitaJson) => ReceitaModel.fromMap(receitaJson))
        .toList();
    return result;
  }
}
