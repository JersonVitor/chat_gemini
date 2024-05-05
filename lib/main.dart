import 'dart:convert';
import 'dart:io';

import 'package:chat_gemini/const/const.dart';
import 'package:chat_gemini/models/IAmodel.dart';
import 'package:chat_gemini/models/messagemodel.dart';
import 'package:chat_gemini/models/receitamodel.dart';
import 'package:chat_gemini/provider/chatprovider.dart';
import 'package:chat_gemini/provider/sql_helper.dart';
import 'package:chat_gemini/widgets/inputtextchatwidget.dart';
import 'package:chat_gemini/widgets/messagebubble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(home: ChatIA()));
}

class ChatIA extends StatefulWidget {
  const ChatIA({super.key});

  @override
  _ChatIAState createState() => _ChatIAState();
}

class _ChatIAState extends State<ChatIA> {
  final TextEditingController textEditingController = TextEditingController();
  final ChatProvider chatProvider = ChatProvider();
  final imagePicker = ImagePicker();
  File? image;
  bool _isVisible = false;
  List<dynamic> messageList = [];

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _carregaMensagens();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF36393f),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: const Text('My.chat', style: TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                  child: Builder(
                      builder: (context) => ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: messageList.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                         if(messageList[index] is MessageModel){
                           return Align(
                             alignment: Alignment.centerRight,
                             child: MessageBubbleWidget(
                                   mensagemChat: messageList[index],
                                   receitas: [])
                           );
                         } else {
                           return  Align(
                               alignment: Alignment.centerLeft,
                             child: MessageBubbleWidget(
                                   mensagemChat: messageList[index].message,
                                   receitas: messageList[index].receitas )
                           );
                         }
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(
                          color: Colors.transparent,
                        ),
                      )
                  )),
              InputTextChatWidget(
                mensagemTextController: textEditingController,
                handleSubmit: _sendMessage,
                imageCam: _pick,
                imageGallery: _pick,
                imageRemove: () {
                  setState(() {
                    image = null;
                  });
                },
                image: image,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      textEditingController.clear();
      MessageModel mensagem = MessageModel(
          author: "jerson",
          message: message,
          isMe: true,
          image: image?.path,
          createdAt: DateTime.now());
      SQLHelper.create(nomeTableChat, mensagem).then((_) {
        setState(() {
          messageList.add(mensagem);
          image = null;
        });
      });
      requestGemini(message);

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _carregaMensagens() {
    SQLHelper.readList(nomeTableChat, "createdAt").then((value) => setState(() {
      List<MessageModel> messages =[];
      List<ReceitaModel> ListaReceitas = [];
      IAModel model ;
          messages = List.generate(value.length, (index) {
            return MessageModel.fromMap(value[index]);
          });

          for(var message in messages){
            if(message.isMe){
              messageList.add(message);
            } else {
              final receitas = message.receitas;
              if(receitas != null){
               receitas.forEach((element) {
                 SQLHelper.read(nomeTableReceitas, element).then((value){
                   ListaReceitas.add(ReceitaModel.fromMap(value[0]));
                 });
               });
              }
              model = IAModel(message: message, receitas: ListaReceitas);
              messageList.add(model);
            }
          }
        }));
  }




  void requestGemini(String message) async {
    await chatProvider.requestChat(message, image).then((value) {
      Map<String, dynamic> dados = jsonDecode(value!);
      List<int> idsReceitas = [];
      List<ReceitaModel> receitas = [];

      if (dados["result"]["receitas"] != null) {

           receitas = ReceitaModel.listaReceitas(dados["result"]["receitas"]);
        for (var element in receitas) {
          SQLHelper.create(nomeTableReceitas, element).then((value) {
            idsReceitas.add(value);
          });
        }
      }
      MessageModel chatIA = MessageModel(
          author: "chat",
          message: dados["result"]["textoResposta"],
          isMe: false,
          receitas: idsReceitas,
          createdAt: DateTime.now());
      SQLHelper.create(nomeTableChat, chatIA).then((value) {
        setState(() {
          messageList.add(IAModel(message: chatIA, receitas: receitas));
        });
      });
    });
  }

  void _setVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      _setVisibility();
    }
  }
}
