import 'dart:io';

import 'package:kantina/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// criando o nosso helper
// camada de persistência
class UserHelper {
  final String databaseName = "meuleitor.db"; // nome da base
  final int databaseVersion = 1; // versão da base
  late Database db; // variável que representa o banco

  // inicializa o banco de dados
  open() async {
    Directory dbDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDir.path, databaseName);
    db = await openDatabase(dbPath,
        version: databaseVersion, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY autoincrement, name TEXT, email TEXT, password TEXT)");
    await db.execute(
        "insert into user(name, email, password) values('flutter', 'flutter@unoesc.edu.br', 'flutter')");
  }

  // insere o usuário
  Future<int> saveUser(User u) async {
    var dbClient = await db;
    int res = await dbClient.insert("user", u.toMap());
    return res;
  }

  Future<bool> updateUser(User u) async {
    var dbClient = await db;
    int res = await dbClient
        .update("user", u.toMap(), where: "id = ?", whereArgs: [u.id]);
    return res > 0 ? true : false;
  }

  Future<bool> deleteUser(User u) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete("delete from user where id = ?", [u.id]);
    return res > 0 ? true : false;
  }

  // validar login
  Future<User> validateLogin(String email, String password) async {
    var dbClient = await db;
    late User user; // preenche os dados do usuário
    List<Map> list = await dbClient.rawQuery(
        "select * from user where email = ? and password = ?",
        [email, password]);
    if (list.length > 0) {
      user = User(list[0]["id"], list[0]["name"], list[0]["email"],
          list[0]["password"]);
    }

    return user;
  }
}
