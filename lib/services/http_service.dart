import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:kantina/models/user.dart';

class HttpService {
  static final String usersURL = "";
  static final String paymentURL = "";

  static Future<List<User>> getUsers() async {
    Response res = await get(Uri.parse(usersURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<User> users = List.empty();
      // List<User> users = body
      //     .map(
      //       (dynamic item) => User.fromJson(item),
      //     )
      //     .toList();

      return users;
    } else {
      throw "Erro ao recuperar usuários!";
    }
  }
}