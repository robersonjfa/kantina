import 'package:flutter/material.dart';
import 'package:kantina/services/http_service.dart';

class PromotionsListView extends StatefulWidget {
  @override
  createState() => _BuildListViewState();
}

class _BuildListViewState extends State {
  var promotions = [];

  getPromotions() {
    HttpService.getPromotions().then((response) {
      setState(() {
        promotions = List.from(response);
      });
    });
  }

  initState() {
    super.initState();
    getPromotions();
  }

  @override
  build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        return ListTile(
            onTap: null,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            tileColor: Colors.green[50],
            title: Text('Produto: ' + promotions[index].product,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text('Valor: R\$ ' + promotions[index].value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
      },
    );
  }
}
