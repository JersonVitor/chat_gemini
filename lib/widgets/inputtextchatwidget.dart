import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTextChatWidget extends StatelessWidget{
  const InputTextChatWidget({super.key, required this.mensagemTextController, required this.handleSubmit, required this.imagePicker});
  final TextEditingController mensagemTextController;
  final Function(String mensagem) handleSubmit;
  final Function() imagePicker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            Flexible(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  controller: mensagemTextController,
                  cursorColor: Colors.green,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.all(20.0),
                      filled: true,
                      fillColor: Color(0xff2f3136),
                      labelText: 'Message',
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60),bottomLeft: Radius.circular(60)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(60),bottomLeft: Radius.circular(60)),
                        gapPadding: 8.0,
                      )
                  ),
                  onSubmitted:(text) => handleSubmit(text),
                )
            ),
            Container(
              margin: const EdgeInsets.only(right: 4),

              decoration: const BoxDecoration(
                color: Color(0xff2f3136),
                borderRadius:  BorderRadius.only(topRight: Radius.circular(60),bottomRight: Radius.circular(60)),
              ),
              child: Center(
                 child:  IconButton(
                   padding: const EdgeInsets.all(20),
                    onPressed: () =>imagePicker(),
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.white,
                  )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () => handleSubmit(mensagemTextController.text),
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

}