import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/pages/events.dart';
import 'package:myapp/pages/favorited.dart';
import 'package:myapp/pages/teams.dart';



void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  void onItemTapped(int index){
    setState((){
      selectedIndex = index;
    });
  }

  var titles = ["Events", "Teams", "Favorited"];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar : AppBar(
            backgroundColor: Colors.lightGreen,
            title: Text("${titles[selectedIndex]}")
          ),

          // floatingActionButton: FloatingActionButton(
          //   child:const Icon(Icons.add),
          //   onPressed: (){
              
          //     print("Among Us");
          //   },
          // ),

          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Events",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorited"),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),

          drawer: const Drawer(
            child: Text("Yo"),
            backgroundColor: Colors.blueGrey,
          ),

          // body: ListView(
          //   scrollDirection: Axis.vertical,
          //   addAutomaticKeepAlives: false,
          //   children: [
          //     Container(color: Colors.red, width: 100, height: 500),
          //     Container(color: Colors.blue, width: 100, height: 500),
          //     Container(color: Colors.yellow, width: 100, height: 500)
          //   ],
          // ) 
          // body: ListView.builder(
          //   itemBuilder: (_, index){
          //     return Container(
          //       color: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)),
          //       width: 100,
          //       height: 100
          //     );
          // },
          // )
          body: <Widget>[Events(), Teams(), Favorited()][selectedIndex]
         
           
      )


    );
  }
}