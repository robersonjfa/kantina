import 'package:kantina/pages/principal_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = const TextStyle(fontSize: 20); // estilo geral
  // a ideia hoje é usar o conceito de formulário do flutter - widget form
  String? _usuario = "";
  String? _senha = "";

  final frmLoginKey =
      new GlobalKey<FormState>(); // serve como identificador do formulário
  void _validarLogin() async {
    // capturando o estado atual do formulário
    final form = frmLoginKey.currentState;

    if (form!.validate()) {
      form.save();

      // validando usuário e senha
      if (_usuario != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PrincipalPage()));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Erro Login"),
                  content: Text("Usuário e/ou senha inválidos!"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))));
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // campo usuario
    final usuarioField = TextFormField(
      style: style,
      onSaved: (valor) => _usuario = valor,
      validator: (valor) {
        return valor!.length < 15
            ? "Usuário deve ter no mínimo 15 caracteres!"
            : null;
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "E-mail",
          labelText: "E-mail",
          suffixIcon: Icon(
            Icons.login,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );

    final senhaField = TextFormField(
      obscureText: true,
      style: style,
      onSaved: (valor) => _senha = valor,
      validator: (valor) {
        return valor!.length < 6 ? "Senha inválida!" : null;
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Senha",
          labelText: "Senha",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          suffixIcon: Icon(
            Icons.password,
          )),
    );

    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.greenAccent,
                    child: Padding(
                        padding: const EdgeInsets.all(36),
                        child: Form(
                            key: frmLoginKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                    height: 155,
                                    child: Image.asset(
                                        'assets/images/splash.png')),
                                const SizedBox(
                                  height: 45,
                                ),
                                usuarioField,
                                const SizedBox(
                                  height: 25,
                                ),
                                senhaField,
                                const SizedBox(
                                  height: 35,
                                ),
                                ElevatedButton(
                                  onPressed: _validarLogin,
                                  child: Text("Login", style: style),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const Text("teste")),
                                    child: const Text("Registrar",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.orange)))
                              ],
                            )))))));
  }
}