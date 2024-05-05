import 'package:chat_gemini/models/database.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:chat_gemini/const/const.dart';
class SQLHelper {
  static Future<void> criaTabela(String nomeTable, sql.Database database) async {
    switch(nomeTable){
      case nomeTableChat:{
        await database.execute("""CREATE TABLE $nomeTableChat(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        author TEXT,
        message TEXT,
        image TEXT,
        isMe INTEGER,
        receitas TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      }break;
      case nomeTableReceitas:{
        await database.execute("""CREATE TABLE $nomeTableReceitas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        key TEXT,
        nomeReceita TEXT,
        descricao TEXT,
        image TEXT,
        numPorcoes INTEGER,
        tempo INTEGER,
        categoria TEXT,
        avaliacao INTEGER,
        ingredientes TEXT,
        modoDePreparo TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    }break;
      default: throw Exception("Nome de tabela $nomeTable inexistente!!");
    }
  }

  static Future<sql.Database> db(String nomeTable) async {
    return sql.openDatabase(
      '$nomeTable.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(nomeTable,database);
      },
    );
  }

  static Future<int> create(String nomeTable,dynamic model) async {
    final db = await SQLHelper.db(nomeTable);
    int id = -1;
    if(model is DBModel){
      final dados = model.toJson();
       id = await db.insert(nomeTable, dados,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
    return id ;
  }

  static Future<List<Map<String, dynamic>>> readList(String nomeTable,String variavelOrdem) async {
    final db = await SQLHelper.db(nomeTable);
    List<Map<String, dynamic>> dados ;
   try{
     dados = await db.query(nomeTable, orderBy: "$variavelOrdem ASC");
   }catch(e){
      print("Erro na leitura de dados $e");
      dados = [];
   }
    return dados;
  }

  static Future<List<Map<String, dynamic>>> read(String nomeTable,int id) async {
    final db = await SQLHelper.db(nomeTable);
    return db.query(nomeTable, where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> update(String nomeTable,dynamic model,int id) async {
    final db = await SQLHelper.db(nomeTable);
    int result = -1;
    if(model is DBModel) {
      final dados = model.toJson();
      result =
      await db.update(nomeTable, dados, where: "id = ?", whereArgs: [id]);
    }
    return result;
  }

 static Future<void> delete(String nomeTable,int id) async {
    final db = await SQLHelper.db(nomeTable);
    try {
      await db.delete(nomeTable, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Erro ao apagar o item item: $err");
    }
  }
}