import 'package:chat_gemini/models/messagemodel.dart';
import 'package:chat_gemini/models/receitamodel.dart';


class IAModel {
  MessageModel message;
  List<ReceitaModel> receitas;
  IAModel({required this.message,required this.receitas});
}