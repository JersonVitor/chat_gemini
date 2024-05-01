class MessageModel{
  final String author;
  final String message;
  final String? image;
  final bool isMe;
  final DateTime? createdAt;


  MessageModel({required this.author,required this.message,this.image,required this.isMe,this.createdAt});

  Map<String, dynamic> toJson(){
    return {
      "author":    author,
      "message":   message,
      "image":     image,
      "isMe":      isMe? 1:0
    };
  }
  factory MessageModel.fromMap(Map<String,dynamic> map){
    return MessageModel(
        author: map["author"],
        message: map["message"],
        isMe: map["isMe"] == 1? true: false,
        createdAt: DateTime.parse(map["createdAt"]));
  }

}