import 'dart:io';

import 'package:chat_gemini/models/receitamodel.dart';
import 'package:flutter/material.dart';

class CardChatWidget extends StatelessWidget{
  const CardChatWidget({super.key, required this.save, required this.openScreen, required this.receita});
  final Function() save;
  final Function() openScreen;
  final ReceitaModel receita;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child:  SizedBox(
        width: 300,
        child: Container(
          color: Colors.grey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem
              SizedBox(
                  width: 80,

              ),
              SizedBox(width: 10),
              // Coluna com Nome da Receita, Ícone e Botão
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row com Nome da Receita e Ícone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          receita.nomeReceita,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite),
                          onPressed: save,
                        ),
                      ],
                    ),
                    // Botão para abrir a receita
                 Align(
                   alignment: Alignment.centerRight,
                   child:ElevatedButton(
                     onPressed: openScreen,
                     child: Text('Abrir Receita'),
                   ),
                 )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
/*

 */
}