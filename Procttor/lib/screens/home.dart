import 'package:flutter/material.dart';
import 'package:procttor/services/user_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: GestureDetector(onTap:(){logout();}, child: Text('log out'),),)
    );
  }
}
