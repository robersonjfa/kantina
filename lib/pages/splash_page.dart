import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final Tween<double> turnsTween = Tween<double>(begin: 1, end: 10);

  // inicializado tardia ou atrasada
  late AnimationController controller;

  void navegarTelaLogin() {
    // para chamar outra tela
    // utilizamos o objeto Navigator
    Navigator.pushReplacementNamed(context, '/login');
  }

  iniciarSplash() async {
    var duracao = Duration(seconds: 5);
    controller.forward(); // executa animação
    return Timer(duracao, navegarTelaLogin);
  }

  @override
  void initState() {
    super.initState();
    // criando o controle de animação
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    iniciarSplash();
  }

  @override
  Widget build(BuildContext context) {
    // reproduzir um fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
        body: Container(
            // utilizamos o MediaQuery para saber o
            // tamanho de tela disponível
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                    turns: turnsTween.animate(controller),
                    child: Image.asset("assets/images/splash.png")),
                SizedBox(
                  height: 40,
                ),
                Text(FlutterI18n.translate(context, "txt_splash"),
                    style: TextStyle(fontSize: 35))
              ],
            )));
  }
}
