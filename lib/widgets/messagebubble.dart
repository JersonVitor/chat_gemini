import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/messagemodel.dart';
import '../models/receitamodel.dart';
import 'cardchatwidget.dart';
class MessageBubbleWidget extends StatelessWidget{
  const MessageBubbleWidget({super.key,required this.mensagemChat,required this.receitas});
  final MessageModel mensagemChat;
  final List<ReceitaModel> receitas;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: mensagemChat.isMe ? Colors.green : Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      width: mensagemChat.isMe ? 200 : 300, // Defina o tamanho fixo do Container
      child: Column(
        crossAxisAlignment:mensagemChat.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: mensagemChat.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  // Remova a definição de largura do Container interno
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mensagemChat.author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      if(mensagemChat.image != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(mensagemChat.image!),
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                      Text(
                        mensagemChat.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: mensagemChat.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Expanded(
                child: !mensagemChat.isMe
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    receitas.length,
                        (index) => Column(
                      children: [
                        CardChatWidget(
                          save: () {},
                          openScreen: () {},
                          receita: receitas[index],
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

