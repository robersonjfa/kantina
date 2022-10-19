import 'package:flutter/material.dart';
import 'package:kantina/pages/map_page.dart';
import 'package:kantina/pages/payment_page.dart';
import 'package:kantina/pages/principal_page.dart';
import 'package:kantina/pages/login_page.dart';

// rotas de navegação
final routes = {
  '/login': (BuildContext context) => 
    LoginPage(),
  '/principal': (BuildContext context) => 
    PrincipalPage(),
  '/map': (BuildContext context) => 
    MapPage(),
  '/payment': (BuildContext context) => 
    paymentpage(),
}
;