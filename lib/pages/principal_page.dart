import 'dart:async';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kantina/models/user.dart';

class PrincipalPage extends StatefulWidget {
  final User? user;
  PrincipalPage({Key? key, this.user}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  double? scanValue;

  List<String> purchases = [
    "Compra de créditos no valor de R\$ 20,00 em 10/10/2022",
    "Compra de pastel no valor de R\$ 4,00 em 12/10/2022",
    "Compra de mini-pizza no valor de R\$ 6,00 em 12/10/2022",
  ];

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
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
                  "R\$ ${scanValue ?? 0}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.green),
                )),
          ),
        ),
        SizedBox(height: 20),
        Flexible(
            child: ListView.builder(
                itemCount: purchases.length,
                itemBuilder: (context, idx) {
                  return Text(purchases[idx]);
                }))
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
                Navigator.of(context).pushNamed('/BackupPage');
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
      if (value == null)
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

      setState(() => scanValue = value);
    } on PlatformException catch (e) {
      // setState(() {
      //   scanResult = ScanResult(
      //     type: ResultType.Error,
      //     format: BarcodeFormat.unknown,
      //     rawContent: e.code == BarcodeScanner.cameraAccessDenied
      //         ? 'Problema de permissão para acessar a câmera!'
      //         : 'Erro: $e',
      //   );
      // });
    }
  }
}
