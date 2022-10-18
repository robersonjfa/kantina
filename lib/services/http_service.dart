import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static final String usersURL = "";
  static final String paymentURL = "";

  // Future<List<Post>> getPosts() async {
  //   Response res = await get(postsURL);

  //   if (res.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(res.body);

  //     List<Post> posts = body
  //       .map(
  //         (dynamic item) => Post.fromJson(item),
  //       )
  //       .toList();

  //     return posts;
  //   } else {
  //     throw "Unable to retrieve posts.";
  //   }
  // }
}