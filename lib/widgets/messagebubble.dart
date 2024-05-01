import 'package:flutter/material.dart';
import '../models/messagemodel.dart';
class MessageBubbleWidget extends StatelessWidget{

  final MessageModel mensagemChat;
  final bool isMe;
  const MessageBubbleWidget({super.key,required this.mensagemChat,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe? MainAxisAlignment.end: MainAxisAlignment.start,
          children: [
              Container(
                padding: const EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                       mensagemChat.author,
                       style: const TextStyle(
                           color: Colors.white,
                           fontSize: 10
                       )
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