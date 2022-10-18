import 'dart:async';
import 'dart:io' show Platform;

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
  ScanResult? scanResult;

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
          IconButton(onPressed: _scan, icon: Icon(Icons.qr_code_scanner_rounded))
        ],
      ),
      body: Center(child: Text("${scanResult?.rawContent}", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.green),)),
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
                Navigator.of(context).pushNamed('/PaymentPage');
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
                // TODO: Implementar o sair da aplicação
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
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
