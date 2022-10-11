import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kantina/models/user.dart';

class PrincipalPage extends StatefulWidget {
  final User? user;
  PrincipalPage({Key? key, this.user}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.qr_code_scanner_rounded))
        ],
      ),
      body: Center(child: Text("Tela Principal")),
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
}
