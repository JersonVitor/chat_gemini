import 'dart:convert';
import 'dart:io';

import 'package:chat_gemini/const/const.dart';
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
                            itemBuilder: (context, index) =>
                                MessageBubbleWidget(
                                    mensagemChat: messageList[index],
                                    isMe: messageList[index].isMe,
                                    image: messageList[index].image),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              color: Colors.transparent,
                            ),
                          ))),
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
      chatProvider.teste().then((value) {
        Map<String, dynamic> dados = jsonDecode(value!);
        List<ReceitaModel> receitas =
            ReceitaModel.listaReceitas(dados["result"]["receitas"]);
        List<int> idsReceitas = [];
        for (var element in receitas) {
          SQLHelper.create(nomeTableReceitas, element)
              .then((value) => {idsReceitas.add(value)});
        }

        MessageModel chatIA = MessageModel(
            author: "chat",
            message: dados["result"]["textoResposta"],
            isMe: false,
            receitas: idsReceitas,
            createdAt: DateTime.now());
        print(chatIA.toJson());
        SQLHelper.create(nomeTableChat, chatIA).then((value) {
          setState(() {
            messageList.add(chatIA);
          });
        });
      });
      List<ReceitaModel> receitas = [];
      SQLHelper.readList(nomeTableReceitas, "id").then((value) {
        receitas =  List.generate(value.length, (index) {
          return ReceitaModel.fromMap(value[index]);
        });
      });
      //requestGemini(message);

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
          messageList = List.generate(value.length, (index) {
            return MessageModel.fromMap(value[index]);
          });
        }));
  }

  void requestGemini(String message) {
    String response = "Não foi possível responder";
    chatProvider.requestWithImage(message, image!).then((value) {
      if (value != null) response = value;
      MessageModel IAResponse = MessageModel(
          author: "IA",
          message: response,
          isMe: false,
          createdAt: DateTime.now());
      SQLHelper.create(nomeTableChat, IAResponse).then((_) {
        setState(() {
          messageList.add(IAResponse);
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
