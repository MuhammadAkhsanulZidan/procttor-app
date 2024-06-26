import 'dart:io';

import 'package:procttor/screens/loadingscreen.dart';
import 'package:procttor/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback=
        (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global=new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}