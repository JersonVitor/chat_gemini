import 'package:chat_gemini/models/messagemodel.dart';
import 'package:chat_gemini/provider/chatprovider.dart';
import 'package:chat_gemini/provider/sql_helper.dart';
import 'package:chat_gemini/widgets/inputtextchatwidget.dart';
import 'package:chat_gemini/widgets/messagebubble.dart';
import 'package:flutter/material.dart';

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

  List<MessageModel> messageList = [];

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
                                    isMe: messageList[index].isMe),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              color: Colors.transparent,
                            ),
                          ))),
              InputTextChatWidget(
                  mensagemTextController: textEditingController,
                  handleSubmit: _sendMessage,
              imagePicker: _imagePicker ),
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
          author: "jerson", message: message, isMe: true, createdAt: DateTime.now());
      SQLHelper.adicionarMensagem(mensagem).then((_) {
        setState(() {
          messageList.add(mensagem);
        });
      });
      MessageModel mensagem2 = MessageModel(
          author: "IA", message: "olá", isMe: false, createdAt: DateTime.now());
      SQLHelper.adicionarMensagem(mensagem).then((_) {
        setState(() {
          messageList.add(mensagem2);
        });
      });
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
    SQLHelper.pegaMensagens().then((value) => setState(() {
      messageList = value;
    }));
  }
  void _imagePicker(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
