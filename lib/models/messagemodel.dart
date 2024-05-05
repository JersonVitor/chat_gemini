import 'dart:convert';

import 'package:chat_gemini/models/database.dart';

class MessageModel implements DBModel{
  final String author;
  final String message;
  final String? image;
  final bool isMe;
  final List<int>? receitas;
  final DateTime? createdAt;


  MessageModel({required this.author,required this.message,this.image,required this.isMe,this.receitas,this.createdAt});

  @override
  Map<String, dynamic> toJson(){
    return {
      "author":    author,
      "message":   message,
      "image":     image,
      "isMe":      isMe? 1:0,
      "receitas": jsonEncode(receitas),
    };
  }


  factory MessageModel.fromMap(Map<String, dynamic> map) {
    List<int> idsReceitas = [];
    String r = map["receitas"].replaceAll("[","").replaceAll("]","").replaceAll("null","");

    if(r != ""){
      List<String> split = r.split(",");
      print(split.toList());
      idsReceitas  = split.map((str) => int.parse(str)).toList();
     }

    return MessageModel(
      author: map["author"],
      message: map["message"],
      image: map["image"],
      isMe: map["isMe"] == 1 ? true : false,
      receitas: idsReceitas,
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }



}