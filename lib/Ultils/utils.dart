
import 'dart:convert';

class Utils{
  static Map<String,dynamic> jsonDecodeChat(String json){
    return jsonDecode(json);
  }
}