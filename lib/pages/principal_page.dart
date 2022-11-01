import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kantina/helpers/user_helper.dart';
import 'package:kantina/models/user.dart';
import 'package:kantina/services/http_service.dart';
import 'package:kantina/widgets/promotions_listview.dart';

class PrincipalPage extends StatefulWidget {
  final User? user;
  PrincipalPage({Key? key, this.user}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  var userHelper = UserHelper();
  double? paymentValue = 0.0;

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  updatePaymentValue(double value) async {
    await userHelper.updatePaymentValue(value);
    double? payValue = await userHelper.sumAvailablePayment();
    setState(() {
      paymentValue = payValue;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await userHelper.open();
      double? payValue = await userHelper.sumAvailablePayment();
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {
        paymentValue = payValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: _scan, icon: Icon(Icons.qr_code_scanner_rounded))
        ],
      ),
      body: Column(children: [
        SizedBox(height: 20),
        Container(
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.yellow, borderRadius: BorderRadius.circular(100)
                //more than 50% of width makes circle
                ),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "R\$ ${paymentValue}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.green),
                )),
          ),
        ),
        SizedBox(height: 20),
        Flexible(child: PromotionsListView())
      ]),
      drawer: Drawer(
        // adicionar um widget ListView(lista de itens(ListTile))
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              // widget é para acessar a variável user que está no StatefulWidget
              // alterar o model User para que ele tenha name(nome)
              // vcs precisam adicionar um name para o User
              accountName: Text(widget.user!.name),
              accountEmail: Text(widget.user!.email),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/icone.png')),
            ),
            ListTile(
              title: Text('Forma de Pagamento'),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            ListTile(
              title: Text('Backup'),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Backup"),
                          content: Row(children: [
                            Icon(Icons.backup_outlined),
                            Text(
                                "Deseja realizar o backup dos \ndados no servidor?")
                          ]),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  EasyLoading.show(status: 'Sincronizando...');
                                  Future.delayed(Duration(seconds: 10),
                                      () async {
                                    List<User> users =
                                        await userHelper.listUsers();
                                    users.forEach((u) {
                                      print(u.email);
                                      print(HttpService.createUser(u));
                                    });
                                    EasyLoading.dismiss();
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: const Text('Sim')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Não')),
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))));
                    });
              },
            ),
            ListTile(
              title: Text('Sair'),
              leading: Icon(SimpleLineIcons.close),
              onTap: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      double? value = double.tryParse(result.rawContent.replaceFirst(',', '.'));
      if (value == null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Erro"),
                  content: Row(children: [
                    Icon(Icons.error_rounded),
                    Text("Valor escaneado inválido!")
                  ]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Compra"),
                  content: Row(children: [
                    Icon(Icons.lunch_dining_outlined),
                    Text("Tem certeza que deseja realizar \na compra?")
                  ]),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          updatePaymentValue(value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar')),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))));
            });
      }
    } on PlatformException catch (e) {
      log("Erro: $e");
    }
  }
}
