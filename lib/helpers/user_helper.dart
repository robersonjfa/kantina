import 'dart:developer';
import 'dart:io';

import 'package:kantina/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// criando o nosso helper
// camada de persistência
class UserHelper {
  final String databaseName = "kantina.db"; // nome da base
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
        "CREATE TABLE user(id INTEGER PRIMARY KEY autoincrement, name TEXT, email TEXT, password TEXT, latitude NUMERIC, longitude NUMERIC, photo TEXT)");
    await db.execute(
        "CREATE TABLE user_payment(id INTEGER PRIMARY KEY autoincrement, userid INTEGER, description TEXT UNIQUE, value NUMERIC)");

    await db.execute(
        "insert into user(name, email, password) values('flutter', 'flutter@unoesc.edu.br', 'flutter')");
    await db.execute(
        "insert into user_payment(userid, description, value) values(1, 'Cartão MasterCard', 50.50)");
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
    int res = await dbClient.
        // $1, :email
        rawDelete("delete from user where id = ?", [u.id]);
    return res > 0 ? true : false;
  }

  // validar login
  Future<User?> validateLogin(String email, String password) async {
    var dbClient = await db;
    User? user; // preenche os dados do usuário
    List<Map> list = await dbClient.rawQuery(
        "select * from user where email = ? and password = ?",
        [email, password]);
    if (list.length > 0) {
      user = User(
          list[0]["id"],
          list[0]["name"],
          list[0]["email"],
          list[0]["password"],
          list[0]["latitude"],
          list[0]["longitude"],
          list[0]["photo"]);
    }

    return user;
  }

  Future<double?> sumAvailablePayment() async {
    var dbClient = await db;
    double? value = 0.0;
    List<Map> list =
        await dbClient.rawQuery("select sum(value) valuesum from user_payment");
    if (list.length > 0) {
      value = double.parse((list[0]["valuesum"]).toString());
    }

    return value;
  }

  Future<void> updatePaymentValue(double value) async {
    var dbClient = await db;
    await dbClient
        .rawUpdate("update user_payment set value = (value - ?)", [value]);
  }

  Future<List<User>> listUsers() async {
    var dbClient = await db;
    List<User> users = []; // preenche os dados do usuário
    List<Map> list = await dbClient.rawQuery("select * from user");
    list.forEach((u) { 
         users.add(User(
          u["id"],
          u["name"],
          u["email"],
          u["password"],
          u["latitude"],
          u["longitude"],
          u["photo"]));
    });

    return users;
  }
}
