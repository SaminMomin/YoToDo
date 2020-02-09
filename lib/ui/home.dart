import 'package:flutter/material.dart';

import 'NextScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yo! ToDo',style: TextStyle(
          color:Colors.red,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: NextScreen(),
    );
  }
}