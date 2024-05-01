import 'package:chat_gemini/models/messagemodel.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:chat_gemini/const/const.dart';
class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {
    await database.execute("""CREATE TABLE $nomeTableChat(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        author TEXT,
        message TEXT,
        image TEXT,
        isMe INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      '$nomeTableChat.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> adicionarMensagem(MessageModel model) async {
    final db = await SQLHelper.db();
    final dados = model.toJson();
    final id = await db.insert(nomeTableChat, dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<MessageModel>> pegaMensagens() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> dados = await db.query(nomeTableChat, orderBy: "createdAt ASC");
    return List.generate(dados.length, (index) {
      return MessageModel(
        author: dados[index]['author'],
        message: dados[index]['message'],
        image: dados[index]['image'],
        isMe: dados[index]['isMe'] ==1? true : false,
        createdAt: DateTime.parse(dados[index]['createdAt'])
      );
    });
  }

  static Future<List<Map<String, dynamic>>> pegaUmProduto(int id) async {
    final db = await SQLHelper.db();
    return db.query(nomeTableChat, where: "id = ?", whereArgs: [id], limit: 1);
  }

/*  static Future<int> atualizaProduto(
      int id, String nome, double valor, int ean, int qte) async {
    final db = await SQLHelper.db();

    final dados = {
      'nome': nome,
      'valor': valor,
      'ean': ean,
      'qte': qte,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update(nomeTableChat, dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

 static Future<void> apagaProduto(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("produtos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item item: $err");
    }
  }*/
}