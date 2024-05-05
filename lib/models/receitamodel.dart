import 'dart:convert';

import 'package:chat_gemini/models/database.dart';

class ReceitaModel implements DBModel {
  int? id;
  String nomeReceita;
  String? author;
  int? numPorcoes;
  int? tempo;
  String? categoria;
  int? avaliacao;
  List<String> ingredientes;
  List<String> modoPreparo;
  DateTime? createdAt;

  ReceitaModel(
      {this.id,
      required this.nomeReceita,
      this.author,
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
      "nomeReceita": nomeReceita,
      "author": author,
      "numPorcoes": numPorcoes,
      "tempo": tempo,
      "categoria": categoria,
      "avaliacao": avaliacao,
      "ingredientes": jsonEncode(ingredientes),
      "modoDePreparo": jsonEncode(modoPreparo)
    };
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
  print(map["ingredientes"]);
    return ReceitaModel(
        id: (map["id"] != null)? map["id"] : -1,
        nomeReceita: map["nomeReceita"],
        author: (map["author"] != null)? map["author"] : "Chat",
        numPorcoes: map["numPorcoes"],
        tempo: map["tempo"],
        categoria: map["categoria"],
        avaliacao: (map["avaliacao"] != null)? map["avaliacao"]: 3,
        ingredientes: List<String>.from(map["ingredientes"]),
        modoPreparo: List<String>.from(map["modoDePreparo"]),
        createdAt: (map["createdAt"] != null)? DateTime.parse(map["createdAt"]) : DateTime.now());
  }

  static List<ReceitaModel> listaReceitas(List<dynamic> receitas){
    List<ReceitaModel> result = receitas.map((receitaJson) => ReceitaModel.fromMap(receitaJson)).toList();
    return result;
  }
}
