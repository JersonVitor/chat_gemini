import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/messagemodel.dart';
class MessageBubbleWidget extends StatelessWidget{
  const MessageBubbleWidget({super.key,required this.mensagemChat,required this.isMe, this.image});
  final MessageModel mensagemChat;
  final bool isMe;
  final String? image;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe? MainAxisAlignment.end: MainAxisAlignment.start,
          children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: isMe
                    ?const EdgeInsets.only(left: 10)
                    :const EdgeInsets.only(right: 10),
                width: 200,
                decoration:BoxDecoration(
                  color: isMe
                      ? Colors.green
                      : Colors.black,
                  borderRadius: BorderRadius.circular(15)
                ),
                child:  Column(
                  crossAxisAlignment:isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
                 children: [
                   Text(
                       mensagemChat.author,
                       style: const TextStyle(
                           color: Colors.white,
                           fontSize: 10
                       )
                   ),

                   if(image != null)
                     Padding(
                       padding: const EdgeInsets.only(top: 10.0,bottom: 5.0),
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(15),
                         child: Image.file(
                           File(image!),
                         ),
                       ),
                     ),
                   const SizedBox(height: 5),
                   Text(
                       mensagemChat.message,
                       style: const TextStyle(
                           color: Colors.white,
                           fontSize: 14
                       )
                   )
                 ]
                ),
              )
          ]
        )
      ],
    );
  }

}