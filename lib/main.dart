import 'package:flutter/material.dart';
import 'package:kantina/pages/splash_page.dart';
import 'package:kantina/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
      home: SplashPage(),
    );
  }
}
