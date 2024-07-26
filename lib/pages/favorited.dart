import 'package:flutter/material.dart';

class Favorited extends StatelessWidget{
  const Favorited({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: Container(
        child: Text("Favorited events and teams will show up here"),
        alignment: Alignment.center,
      )
    );
  }
}