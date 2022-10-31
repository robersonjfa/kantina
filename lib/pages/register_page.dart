import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kantina/helpers/user_helper.dart';
import 'package:kantina/models/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = "";
  String _email = "";
  String _password = "";
  double _latitude = -1.0;
  double _longitude = -1.0;
  File? _image;
  var userHelper = UserHelper();
  var _latController = TextEditingController();
  var _lngController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final frmRegisterKey =
      new GlobalKey<FormState>(); // serve como identificador do formulário

  // método para fechar a tela
  void _closeRegister() {
    Navigator.pop(context, true); // fechar a janela de registro
  }

  void _openMaps() async {
    var location = 
    await Navigator.pushNamed(context, '/map');
    var latlng = location.toString().split(",");
    _latController.text = latlng[0];
    _lngController.text = latlng[1];
  }

  // método para registrar o usuário
  void _registerUser() async {
    // capturando o estado atual do formulário
    final form = frmRegisterKey.currentState;
    await userHelper.open(); // é assincrono então precisa do await

    var bytes = null;
    var photo = null;
    if (_image != null) {
      bytes = await _image!.readAsBytes();
      photo = base64.encode(bytes);
    }

    // valido o formulário
    if (form!.validate()) {
      form.save();
      
      var user =
          User(0, _name, _email, _password, _latitude, _longitude, photo);
      // o id e retornado do banco de dados
      user.id = await userHelper
          .saveUser(user); // aqui salva no banco de dados - precisa do await
      if (user.id > 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Sucesso'),
                  content: Text('Registro realizado com sucesso!'));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Erro'),
                  content: Text('Erro ao registrar usuário!'));
            });
      }
    }
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Origem da Foto"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Câmera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galeria"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await _picker.getImage(
          source: imageSource, maxHeight: 400, maxWidth: 300);
      if (file != null) {
        setState(() => _image = File(file.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: frmRegisterKey,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Registrar usuário",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo),
                        color: Color(0xFF4B9DFE),
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        onPressed: _pickImage,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _image == null
                          ? Text('Sem Foto!')
                          : Image.file(
                              _image!,
                              height: 30,
                              width: 30,
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onSaved: (val) => _name = val.toString(),
                        decoration: InputDecoration(labelText: "Nome"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onSaved: (val) => _email = val.toString(),
                        decoration: InputDecoration(labelText: "E-mail"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        onSaved: (val) => _password = val.toString(),
                        decoration: InputDecoration(labelText: "Senha"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Senha deve ter no mínimo 6 caracteres!",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        readOnly: true,
                        onSaved: (val) =>
                            _latitude = double.parse(val.toString()),
                        decoration: InputDecoration(labelText: "Latitude"),
                        controller: _latController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        onSaved: (val) =>
                            _longitude = double.parse(val.toString()),
                        decoration: InputDecoration(labelText: "Longitude"),
                        controller: _lngController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          TextButton(
                            child: Text("Registrar"),
                            onPressed: _registerUser,
                          ),
                          TextButton(
                            child: Text("Fechar"),
                            onPressed: _closeRegister,
                          ),
                          TextButton(
                            child: Text("Mapa"),
                            onPressed: _openMaps,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}