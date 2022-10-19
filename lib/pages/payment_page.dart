import 'package:flutter/material.dart';

class paymentpage extends StatefulWidget {
  paymentpage({Key? key}) : super(key: key);

  @override
  State<paymentpage> createState() => _paymentpageState();
}

class _paymentpageState extends State<paymentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
      child: TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text("Fechar")),
    ));
  }
}
