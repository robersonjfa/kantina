import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:kantina/models/promotion.dart';
import 'package:kantina/models/user.dart';

class HttpService {
  static final String baseUrl = "https://kantina-api.herokuapp.com";

  static Future<List<Promotion>> getPromotions() async {
    Response res = await get(Uri.parse(baseUrl + "/promotions"));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Promotion> promotions = body
          .map(
            (dynamic item) => Promotion.fromJson(item),
          )
          .toList();

      return promotions;
    } else {
      throw "Erro ao recuperar promoções!";
    }
  }

  static Future<String> createUser(User user) async {
    Response res = await post(
      Uri.parse(baseUrl + "/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toMap()));

    if (res.statusCode == 201) {
      return "User created!";
    } else {
      throw "Error creating user!";
    }
  }
}
