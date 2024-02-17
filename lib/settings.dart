import 'package:flutter/material.dart';

class settings extends StatelessWidget{
  const settings({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(height: 200, width: 200, child: Text("Settings"),),
        ),
      )
    );
  }

}